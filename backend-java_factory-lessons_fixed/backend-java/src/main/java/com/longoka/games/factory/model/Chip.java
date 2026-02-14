package com.longoka.games.factory.model;

public class Chip {

  private final long chipId;
  private final String chipTypeCode;
  private final String title;
  private final String contentMd;

  public Chip(long chipId, String chipTypeCode, String title, String contentMd) {
    this.chipId = chipId;
    this.chipTypeCode = chipTypeCode;
    this.title = title;
    this.contentMd = contentMd;
  }

  public long getChipId() {
    return chipId;
  }

  public String getChipTypeCode() {
    return chipTypeCode;
  }

  public String getTitle() {
    return title;
  }

  public String getContentMd() {
    return contentMd;
  }
}
