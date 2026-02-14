package com.longoka.games.factory.model;

public class AtomTag {

  private final String scope;
  private final String code;
  private final String labelFr;
  private final String descriptionMd;

  public AtomTag(String scope, String code, String labelFr, String descriptionMd) {
    this.scope = scope;
    this.code = code;
    this.labelFr = labelFr;
    this.descriptionMd = descriptionMd;
  }

  public String getScope() {
    return scope;
  }

  public String getCode() {
    return code;
  }

  public String getLabelFr() {
    return labelFr;
  }

  public String getDescriptionMd() {
    return descriptionMd;
  }
}
