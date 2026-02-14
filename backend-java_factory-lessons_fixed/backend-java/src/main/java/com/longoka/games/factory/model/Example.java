package com.longoka.games.factory.model;

public class Example {

  private final long exampleId;
  private final String kgText;
  private final String frText;
  private final String enText;
  private final String notesMd;

  public Example(long exampleId, String kgText, String frText, String enText, String notesMd) {
    this.exampleId = exampleId;
    this.kgText = kgText;
    this.frText = frText;
    this.enText = enText;
    this.notesMd = notesMd;
  }

  public long getExampleId() {
    return exampleId;
  }

  public String getKgText() {
    return kgText;
  }

  public String getFrText() {
    return frText;
  }

  public String getEnText() {
    return enText;
  }

  public String getNotesMd() {
    return notesMd;
  }
}
