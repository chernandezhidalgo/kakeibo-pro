/// La segunda confirmación exige esta palabra, tal cual.
const deleteAccountConfirmationPhrase = 'ELIMINAR';

bool deleteAccountPhraseMatches(String input) =>
    input.trim() == deleteAccountConfirmationPhrase;
