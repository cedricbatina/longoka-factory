package com.longoka.games.factory.model;

import com.fasterxml.jackson.databind.JsonNode;

public class Rule {

  private final long ruleId;
  private final String ruleTypeCode;
  private final String title;
  private final String statementMd;
  private final JsonNode patternJson;
  private final String notesMd;
  private final Integer importanceId;
  private final String importanceCode;

  public Rule(
      long ruleId,
      String ruleTypeCode,
      String title,
      String statementMd,
      JsonNode patternJson,
      String notesMd,
      Integer importanceId,
      String importanceCode) {
    this.ruleId = ruleId;
    this.ruleTypeCode = ruleTypeCode;
    this.title = title;
    this.statementMd = statementMd;
    this.patternJson = patternJson;
    this.notesMd = notesMd;
    this.importanceId = importanceId;
    this.importanceCode = importanceCode;
  }

  public long getRuleId() {
    return ruleId;
  }

  public String getRuleTypeCode() {
    return ruleTypeCode;
  }

  public String getTitle() {
    return title;
  }

  public String getStatementMd() {
    return statementMd;
  }

  public JsonNode getPatternJson() {
    return patternJson;
  }

  public String getNotesMd() {
    return notesMd;
  }

  public Integer getImportanceId() {
    return importanceId;
  }

  public String getImportanceCode() {
    return importanceCode;
  }
}
