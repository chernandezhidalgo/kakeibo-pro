#!/usr/bin/env python3
"""Falla si el SQL toca una tabla fuera del esquema real sin una guarda.

El esquema público confirmado es el de producción. _account_deletion_guard
la crea el propio script. Cualquier otra tabla (user_profiles, auth.users)
solo puede aparecer en SQL dinámico dentro de un bloque que consulte
to_regclass o _has_table.

También falla si una columna que no está confirmada aparece en SQL estático.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FILES = [
    ROOT / "supabase_fixes.sql",
    ROOT / "supabase_rls.sql",
    ROOT / "supabase_rls_rollback.sql",
]

ALLOWED_PUBLIC = {
    "accounts",
    "envelopes",
    "families",
    "family_members",
    "kakeibo_reflections",
    "recurring_rules",
    "savings_goals",
    "sync_queue",
    "transactions",
    "_account_deletion_guard",
}

# Funciones de auth, no tablas.
AUTH_FUNCTIONS = {"uid", "role", "jwt"}

# Columnas que el proyecto real no confirmó. No pueden quedar en SQL estático.
OPTIONAL_COLUMNS = {
    "created_at",
    "display_name",
    "invitation_expires_at",
    "avatar_emoji",
    "created_by_user_id",
    "email",
}

RELATION = re.compile(
    r"""(?ix)
    (?:
        \b(?:from|join|into|update|table|on)\s+public\.([a-z_][a-z0-9_]*)
        |
        \bauth\.([a-z_][a-z0-9_]*)
    )
    """
)

BLOCK = re.compile(
    r"""(?is)
    (?:
        create(?:\s+or\s+replace)?\s+function\b.*?as\s+
        |
        do\s+
    )
    \$([a-z0-9_]*)\$
    (.*?)
    \$\1\$
    """
)


def strip_comments(sql: str) -> str:
    sql = re.sub(r"/\*.*?\*/", " ", sql, flags=re.S)
    return re.sub(r"--[^\n]*", " ", sql)


def mask_dollar_strings(sql: str) -> str:
    """Quita literales $q$ y $pol$. El cuerpo de una función no es un literal."""
    pattern = re.compile(r"\$(q|pol)\$", re.I)
    out = []
    cursor = 0
    while True:
        match = pattern.search(sql, cursor)
        if not match:
            out.append(sql[cursor:])
            break
        tag = match.group(1)
        end = sql.find(f"${tag}$", match.end())
        out.append(sql[cursor:match.start()])
        out.append("''")
        if end < 0:
            break
        cursor = end + len(tag) + 2
    return "".join(out)


def mask_strings(sql: str) -> str:
    """Quita literales para buscar columnas en SQL estático."""
    sql = mask_dollar_strings(sql)
    return re.sub(r"'(?:''|[^'])*'", "''", sql)


def blocks_of(sql: str) -> list[tuple[str, str]]:
    found = []
    covered = []
    for match in BLOCK.finditer(sql):
        found.append((match.group(1), match.group(0)))
        covered.append((match.start(), match.end()))
    # Lo que queda fuera de funciones y DO también se revisa.
    cursor = 0
    rest = []
    for start, end in covered:
        if start > cursor:
            rest.append(sql[cursor:start])
        cursor = end
    if cursor < len(sql):
        rest.append(sql[cursor:])
    if rest:
        found.append(("top", "\n".join(rest)))
    return found


def guard_present(block: str, schema: str, name: str) -> bool:
    if schema == "public" and re.search(
        rf"_has_table\(\s*'{re.escape(name)}'\s*\)",
        block,
    ):
        return True
    if schema == "public" and re.search(
        rf"to_regclass\(\s*format\(\s*'public\.%I'\s*,\s*[a-z_][a-z0-9_]*\s*\)\s*\)",
        block,
        flags=re.I,
    ) and re.search(rf"'{re.escape(name)}'", block):
        # El ALTER/INDEX dinámico recorre una lista que incluye la tabla.
        return True
    return re.search(
        rf"to_regclass\(\s*'{re.escape(schema)}\.{re.escape(name)}'\s*\)",
        block,
    ) is not None


def check_file(path: Path) -> list[str]:
    raw = strip_comments(path.read_text())
    errors: list[str] = []

    for tag, block in blocks_of(raw):
        for match in RELATION.finditer(block):
            public_name, auth_name = match.group(1), match.group(2)
            if public_name:
                name = public_name.lower()
                if name in ALLOWED_PUBLIC:
                    continue
                schema = "public"
            else:
                name = auth_name.lower()
                if name in AUTH_FUNCTIONS:
                    continue
                schema = "auth"
            if guard_present(block, schema, name):
                continue
            snippet = " ".join(match.group(0).split())
            errors.append(
                f"{path.name}: bloque ${tag}$ toca {schema}.{name} sin guarda ({snippet})"
            )

    masked = mask_strings(raw)
    for match in re.finditer(
        r"\b(" + "|".join(sorted(OPTIONAL_COLUMNS)) + r")\b",
        masked,
        flags=re.I,
    ):
        column = match.group(1).lower()
        line_no = masked.count("\n", 0, match.start()) + 1
        errors.append(
            f"{path.name}:{line_no}: columna no confirmada '{column}' en SQL estático"
        )
    return errors


def main() -> int:
    errors: list[str] = []
    for path in FILES:
        if not path.exists():
            errors.append(f"falta {path}")
            continue
        errors.extend(check_file(path))
    if errors:
        print("\n".join(errors))
        return 1
    print("SQL: las tablas fuera del esquema real están guardadas.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
