package com.longoka.games.factory.model;

import java.util.ArrayList;
import java.util.List;

public class Atom {

  private final long atomId;
  private final String lessonRoleCode;
  private final String atomTypeCode;
  private final String atomSubtypeCode;
  private final String form;
  private final String formRaw;
  private final String normalizedForm;
  private final String glossFr;
  private final String glossEn;
  private final String notesMd;

  private List<String> graphemeSeq = new ArrayList<>();
  private List<AtomTag> tags = new ArrayList<>();
  private List<AtomSourceRef> sources = new ArrayList<>();
  private List<AtomGloss> glosses = new ArrayList<>();

  public Atom(
      long atomId,
      String lessonRoleCode,
      String atomTypeCode,
      String atomSubtypeCode,
      String form,
      String formRaw,
      String normalizedForm,
      String glossFr,
      String glossEn,
      String notesMd) {
    this.atomId = atomId;
    this.lessonRoleCode = lessonRoleCode;
    this.atomTypeCode = atomTypeCode;
    this.atomSubtypeCode = atomSubtypeCode;
    this.form = form;
    this.formRaw = formRaw;
    this.normalizedForm = normalizedForm;
    this.glossFr = glossFr;
    this.glossEn = glossEn;
    this.notesMd = notesMd;
  }

  public long getAtomId() {
    return atomId;
  }

  public String getLessonRoleCode() {
    return lessonRoleCode;
  }

  public String getAtomTypeCode() {
    return atomTypeCode;
  }

  public String getAtomSubtypeCode() {
    return atomSubtypeCode;
  }

  public String getForm() {
    return form;
  }

  public String getFormRaw() {
    return formRaw;
  }

  public String getNormalizedForm() {
    return normalizedForm;
  }

  public String getGlossFr() {
    return glossFr;
  }

  public String getGlossEn() {
    return glossEn;
  }

  public String getNotesMd() {
    return notesMd;
  }

  public List<String> getGraphemeSeq() {
    return graphemeSeq;
  }

  public void setGraphemeSeq(List<String> graphemeSeq) {
    this.graphemeSeq = graphemeSeq == null ? new ArrayList<>() : graphemeSeq;
  }

  public List<AtomTag> getTags() {
    return tags;
  }

  public void setTags(List<AtomTag> tags) {
    this.tags = tags == null ? new ArrayList<>() : tags;
  }

  public List<AtomSourceRef> getSources() {
    return sources;
  }

  public void setSources(List<AtomSourceRef> sources) {
    this.sources = sources == null ? new ArrayList<>() : sources;
  }

  public List<AtomGloss> getGlosses() {
    return glosses;
  }

  public void setGlosses(List<AtomGloss> glosses) {
    this.glosses = glosses == null ? new ArrayList<>() : glosses;
  }
}
