package com.longoka.games.factory.model;

public class AtomRelation {

  private final long fromAtomId;
  private final long toAtomId;
  private final String relationTypeCode;
  private final String notesMd;

  public AtomRelation(long fromAtomId, long toAtomId, String relationTypeCode, String notesMd) {
    this.fromAtomId = fromAtomId;
    this.toAtomId = toAtomId;
    this.relationTypeCode = relationTypeCode;
    this.notesMd = notesMd;
  }

  public long getFromAtomId() {
    return fromAtomId;
  }

  public long getToAtomId() {
    return toAtomId;
  }

  public String getRelationTypeCode() {
    return relationTypeCode;
  }

  public String getNotesMd() {
    return notesMd;
  }
}
