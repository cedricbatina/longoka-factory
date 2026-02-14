package com.longoka.games.factory.repo;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.longoka.games.factory.model.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Read-only repository for Longoka "factory" DB (lessons/chips/rules/examples/atoms).
 *
 * Keep this code simple & explicit (small datasets), then optimize later (batch queries) if needed.
 */
public class FactoryLessonRepository {

  private final Connection cx;
  private final ObjectMapper mapper;

  public FactoryLessonRepository(Connection cx, ObjectMapper mapper) {
    this.cx = cx;
    this.mapper = mapper;
  }

  public long getDefaultOrthographyId(String languageCode) throws SQLException {
    String sql = "SELECT orthography_id FROM orthographies "
      + "WHERE language_code=? AND is_default=1 ORDER BY orthography_id LIMIT 1";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      ps.setString(1, languageCode);
      try (ResultSet rs = ps.executeQuery()) {
        if (!rs.next()) {
          throw new SQLException("No default orthography for language_code=" + languageCode);
        }
        return rs.getLong(1);
      }
    }
  }

  public LessonRef getLessonRef(int courseId, int lessonId) throws SQLException {
    String sql = "SELECT lesson_ref_id, platform_id, course_id, lesson_id, position, lesson_group, slug, title, "
      + "status, visibility, created_at, updated_at "
      + "FROM lesson_refs WHERE course_id=? AND lesson_id=? ORDER BY lesson_ref_id LIMIT 1";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      ps.setInt(1, courseId);
      ps.setInt(2, lessonId);
      try (ResultSet rs = ps.executeQuery()) {
        if (!rs.next()) {
          return null;
        }
        return new LessonRef(
          rs.getLong("lesson_ref_id"),
          rs.getInt("platform_id"),
          rs.getInt("course_id"),
          rs.getInt("lesson_id"),
          (Integer) rs.getObject("position"),
          rs.getString("lesson_group"),
          rs.getString("slug"),
          rs.getString("title"),
          rs.getString("status"),
          rs.getString("visibility"),
          rs.getObject("created_at", LocalDateTime.class),
          rs.getObject("updated_at", LocalDateTime.class)
        );
      }
    }
  }

  public List<Chip> listChips(long lessonRefId) throws SQLException {
    String sql = "SELECT c.chip_id, ct.code AS chip_type_code, c.title, c.content_md "
      + "FROM chips c JOIN chip_types ct ON ct.chip_type_id=c.chip_type_id "
      + "WHERE c.lesson_ref_id=? ORDER BY c.chip_id";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      ps.setLong(1, lessonRefId);
      try (ResultSet rs = ps.executeQuery()) {
        List<Chip> out = new ArrayList<>();
        while (rs.next()) {
          out.add(new Chip(
            rs.getLong("chip_id"),
            rs.getString("chip_type_code"),
            rs.getString("title"),
            rs.getString("content_md")
          ));
        }
        return out;
      }
    }
  }

  public List<Rule> listRules(long lessonRefId) throws SQLException {
    String sql = "SELECT r.rule_id, rt.code AS rule_type_code, il.code AS importance_code, r.title, r.statement_md, "
      + "r.pattern_json, r.notes_md "
      + "FROM lesson_rules lr "
      + "JOIN rules r ON r.rule_id=lr.rule_id "
      + "JOIN rule_types rt ON rt.rule_type_id=r.rule_type_id "
      + "LEFT JOIN importance_levels il ON il.importance_id=lr.importance_id "
      + "WHERE lr.lesson_ref_id=? "
      + "ORDER BY lr.importance_id, r.rule_id";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      ps.setLong(1, lessonRefId);
      try (ResultSet rs = ps.executeQuery()) {
        List<Rule> out = new ArrayList<>();
        while (rs.next()) {
          String patternStr = rs.getString("pattern_json");
          JsonNode pattern = null;
          if (patternStr != null && !patternStr.isBlank()) {
            try {
              pattern = mapper.readTree(patternStr);
            } catch (Exception e) {
              // Keep data flowing: we still export the rule; pattern_json stays null.
              pattern = null;
            }
          }
          out.add(new Rule(
            rs.getLong("rule_id"),
            rs.getString("rule_type_code"),
            rs.getString("title"),
            rs.getString("statement_md"),
            pattern,
            rs.getString("notes_md"),
            rs.getString("importance_code")
          ));
        }
        return out;
      }
    }
  }

  public List<Example> listExamples(long lessonRefId) throws SQLException {
    String sql = "SELECT example_id, kg_text, fr_text, en_text, notes_md "
      + "FROM examples WHERE lesson_ref_id=? ORDER BY example_id";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      ps.setLong(1, lessonRefId);
      try (ResultSet rs = ps.executeQuery()) {
        List<Example> out = new ArrayList<>();
        while (rs.next()) {
          out.add(new Example(
            rs.getLong("example_id"),
            rs.getString("kg_text"),
            rs.getString("fr_text"),
            rs.getString("en_text"),
            rs.getString("notes_md")
          ));
        }
        return out;
      }
    }
  }

  public List<Atom> listLessonAtoms(long lessonRefId) throws SQLException {
    String sql = "SELECT a.atom_id, lar.code AS lesson_role_code, t.code AS atom_type_code, st.code AS atom_subtype_code, "
      + "a.form, a.form_raw, a.normalized_form, a.gloss_fr, a.gloss_en, a.notes_md "
      + "FROM lesson_atoms la "
      + "JOIN atoms a ON a.atom_id=la.atom_id "
      + "JOIN atom_types t ON t.atom_type_id=a.atom_type_id "
      + "LEFT JOIN atom_subtypes st ON st.atom_subtype_id=a.atom_subtype_id "
      + "JOIN lesson_atom_roles lar ON lar.lesson_atom_role_id=la.lesson_atom_role_id "
      + "WHERE la.lesson_ref_id=? "
      + "ORDER BY t.code, a.normalized_form";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      ps.setLong(1, lessonRefId);
      try (ResultSet rs = ps.executeQuery()) {
        List<Atom> out = new ArrayList<>();
        while (rs.next()) {
          out.add(new Atom(
            rs.getLong("atom_id"),
            rs.getString("lesson_role_code"),
            rs.getString("atom_type_code"),
            rs.getString("atom_subtype_code"),
            rs.getString("form"),
            rs.getString("form_raw"),
            rs.getString("normalized_form"),
            rs.getString("gloss_fr"),
            rs.getString("gloss_en"),
            rs.getString("notes_md")
          ));
        }
        return out;
      }
    }
  }

  public List<String> getAtomGraphemeSeq(long atomId, long orthographyId) throws SQLException {
    String sql = "SELECT ags.seq, g.grapheme "
      + "FROM atom_grapheme_seq ags "
      + "JOIN graphemes g ON g.grapheme_id=ags.grapheme_id "
      + "WHERE ags.atom_id=? AND ags.orthography_id=? "
      + "ORDER BY ags.seq";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      ps.setLong(1, atomId);
      ps.setLong(2, orthographyId);
      try (ResultSet rs = ps.executeQuery()) {
        List<String> out = new ArrayList<>();
        while (rs.next()) {
          out.add(rs.getString("grapheme"));
        }
        return out;
      }
    }
  }

  public List<AtomTag> listAtomTags(long atomId) throws SQLException {
    String sql = "SELECT tg.scope, tg.code, tg.label_fr, tg.description_md "
      + "FROM atom_tags atg JOIN tags tg ON tg.tag_id=atg.tag_id "
      + "WHERE atg.atom_id=? ORDER BY tg.scope, tg.code";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      ps.setLong(1, atomId);
      try (ResultSet rs = ps.executeQuery()) {
        List<AtomTag> out = new ArrayList<>();
        while (rs.next()) {
          out.add(new AtomTag(
            rs.getString("scope"),
            rs.getString("code"),
            rs.getString("label_fr"),
            rs.getString("description_md")
          ));
        }
        return out;
      }
    }
  }

  public List<AtomGloss> listAtomGlosses(long atomId) throws SQLException {
    String sql = "SELECT language_code, gloss, notes_md FROM atom_glosses WHERE atom_id=? ORDER BY language_code";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      ps.setLong(1, atomId);
      try (ResultSet rs = ps.executeQuery()) {
        List<AtomGloss> out = new ArrayList<>();
        while (rs.next()) {
          out.add(new AtomGloss(
            rs.getString("language_code"),
            rs.getString("gloss"),
            rs.getString("notes_md")
          ));
        }
        return out;
      }
    }
  }

  public List<AtomSourceRef> listAtomSources(long atomId) throws SQLException {
    String sql = "SELECT s.source_id, s.code AS source_code, s.title, s.authors, s.year, s.publisher, s.isbn, s.url, "
      + "s.language_code, s.notes_md, asrc.ref, asrc.quote_md, asrc.comment_md "
      + "FROM atom_sources asrc JOIN sources s ON s.source_id=asrc.source_id "
      + "WHERE asrc.atom_id=? ORDER BY s.source_id";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      ps.setLong(1, atomId);
      try (ResultSet rs = ps.executeQuery()) {
        List<AtomSourceRef> out = new ArrayList<>();
        while (rs.next()) {
          out.add(new AtomSourceRef(
            rs.getLong("source_id"),
            rs.getString("source_code"),
            rs.getString("title"),
            rs.getString("authors"),
            (Integer) rs.getObject("year"),
            rs.getString("publisher"),
            rs.getString("isbn"),
            rs.getString("url"),
            rs.getString("language_code"),
            rs.getString("notes_md"),
            rs.getString("ref"),
            rs.getString("quote_md"),
            rs.getString("comment_md")
          ));
        }
        return out;
      }
    }
  }

  public List<AtomRelation> listRelationsForAtomSet(List<Long> atomIds) throws SQLException {
    if (atomIds == null || atomIds.isEmpty()) {
      return Collections.emptyList();
    }
    // Build an IN (...) with placeholders.
    String in = atomIds.stream().map(x -> "?").collect(Collectors.joining(","));
    String sql = "SELECT ar.from_atom_id, ar.to_atom_id, rt.code AS relation_type_code, ar.notes_md "
      + "FROM atom_relations ar JOIN relation_types rt ON rt.relation_type_id=ar.relation_type_id "
      + "WHERE ar.from_atom_id IN (" + in + ") OR ar.to_atom_id IN (" + in + ") "
      + "ORDER BY ar.relation_type_id, ar.from_atom_id, ar.to_atom_id";
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      int idx = 1;
      for (Long id : atomIds) {
        ps.setLong(idx++, id);
      }
      for (Long id : atomIds) {
        ps.setLong(idx++, id);
      }
      try (ResultSet rs = ps.executeQuery()) {
        List<AtomRelation> out = new ArrayList<>();
        while (rs.next()) {
          out.add(new AtomRelation(
            rs.getLong("from_atom_id"),
            rs.getLong("to_atom_id"),
            rs.getString("relation_type_code"),
            rs.getString("notes_md")
          ));
        }
        return out;
      }
    }
  }

  /**
   * Convenience: builds a full LessonPack in one shot.
   */
  public LessonPack loadLessonPack(int courseId, int lessonId, String languageCodeForOrthography) throws SQLException {
    LessonRef lesson = getLessonRef(courseId, lessonId);
    if (lesson == null) {
      return null;
    }

    long orthographyId = getDefaultOrthographyId(languageCodeForOrthography);

    LessonPack pack = new LessonPack();
    pack.setLesson(lesson);
    pack.getMeta().put("exported_at", LocalDateTime.now().toString());
    pack.getMeta().put("orthography_id", orthographyId);
    pack.getMeta().put("db", "factory");

    pack.getChips().addAll(listChips(lesson.getLessonRefId()));
    pack.getRules().addAll(listRules(lesson.getLessonRefId()));
    pack.getExamples().addAll(listExamples(lesson.getLessonRefId()));

    List<Atom> atoms = listLessonAtoms(lesson.getLessonRefId());
    for (Atom a : atoms) {
      a.getGraphemeSeq().addAll(getAtomGraphemeSeq(a.getAtomId(), orthographyId));
      a.getTags().addAll(listAtomTags(a.getAtomId()));
      a.getSources().addAll(listAtomSources(a.getAtomId()));
      a.getGlosses().addAll(listAtomGlosses(a.getAtomId()));
    }
    pack.getAtoms().addAll(atoms);

    List<Long> atomIds = atoms.stream().map(Atom::getAtomId).collect(Collectors.toList());
    pack.getRelations().addAll(listRelationsForAtomSet(atomIds));

    // Small extra: precompute a map atomId -> normalized_form for UI convenience.
    Map<Long, String> atomIndex = new LinkedHashMap<>();
    for (Atom a : atoms) {
      atomIndex.put(a.getAtomId(), a.getNormalizedForm());
    }
    pack.getMeta().put("atom_index", atomIndex);

    return pack;
  }

  /**
   * Backward-compatible alias used by the CLI tool.
   * Defaults to Kikongo ("kg") for selecting the default orthography.
   */
  public LessonPack exportLessonPack(int courseId, int lessonId) throws SQLException {
    return exportLessonPack(courseId, lessonId, "kg");
  }

  /**
   * Export with an explicit languageCode to pick the default orthography (e.g. "kg", "ln").
   */
  public LessonPack exportLessonPack(int courseId, int lessonId, String languageCodeForOrthography) throws SQLException {
    return loadLessonPack(courseId, lessonId, languageCodeForOrthography);
  }
}
