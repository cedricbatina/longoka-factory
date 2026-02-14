package com.longoka.games.factory.model;

public class AtomGloss {

  private final String languageCode;
  private final String gloss;
  private final String notesMd;

  public AtomGloss(String languageCode, String gloss, String notesMd) {
    this.languageCode = languageCode;
    this.gloss = gloss;
    this.notesMd = notesMd;
  }

  public String getLanguageCode() {
    return languageCode;
  }

  public String getGloss() {
    return gloss;
  }

  public String getNotesMd() {
    return notesMd;
  }
}
