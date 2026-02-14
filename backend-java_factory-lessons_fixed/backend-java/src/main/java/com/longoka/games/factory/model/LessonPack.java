package com.longoka.games.factory.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LessonPack {

  private final Map<String, Object> meta = new HashMap<>();
  private LessonRef lesson;
  private final List<Chip> chips = new ArrayList<>();
  private final List<Rule> rules = new ArrayList<>();
  private final List<Example> examples = new ArrayList<>();
  private final List<Atom> atoms = new ArrayList<>();
  private final List<AtomRelation> relations = new ArrayList<>();

  public Map<String, Object> getMeta() {
    return meta;
  }

  public LessonRef getLesson() {
    return lesson;
  }

  public void setLesson(LessonRef lesson) {
    this.lesson = lesson;
  }

  public List<Chip> getChips() {
    return chips;
  }

  public List<Rule> getRules() {
    return rules;
  }

  public List<Example> getExamples() {
    return examples;
  }

  public List<Atom> getAtoms() {
    return atoms;
  }

  public List<AtomRelation> getRelations() {
    return relations;
  }
}
