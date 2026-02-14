package com.longoka.games.factory.model;

public class AtomSourceRef {

  private final long sourceId;
  private final String sourceCode;
  private final String title;
  private final String authors;
  private final Integer year;
  private final String publisher;
  private final String isbn;
  private final String url;
  private final String languageCode;
  private final String ref;
  private final String quoteMd;
  private final String commentMd;

  public AtomSourceRef(
      long sourceId,
      String sourceCode,
      String title,
      String authors,
      Integer year,
      String publisher,
      String isbn,
      String url,
      String languageCode,
      String ref,
      String quoteMd,
      String commentMd) {
    this.sourceId = sourceId;
    this.sourceCode = sourceCode;
    this.title = title;
    this.authors = authors;
    this.year = year;
    this.publisher = publisher;
    this.isbn = isbn;
    this.url = url;
    this.languageCode = languageCode;
    this.ref = ref;
    this.quoteMd = quoteMd;
    this.commentMd = commentMd;
  }

  public long getSourceId() {
    return sourceId;
  }

  public String getSourceCode() {
    return sourceCode;
  }

  public String getTitle() {
    return title;
  }

  public String getAuthors() {
    return authors;
  }

  public Integer getYear() {
    return year;
  }

  public String getPublisher() {
    return publisher;
  }

  public String getIsbn() {
    return isbn;
  }

  public String getUrl() {
    return url;
  }

  public String getLanguageCode() {
    return languageCode;
  }

  public String getRef() {
    return ref;
  }

  public String getQuoteMd() {
    return quoteMd;
  }

  public String getCommentMd() {
    return commentMd;
  }
}
