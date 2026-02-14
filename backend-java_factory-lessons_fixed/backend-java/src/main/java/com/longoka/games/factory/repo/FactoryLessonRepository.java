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

  /**
   * Generic helper to execute a query and map results using a ResultSetMapper.
   * Reduces boilerplate in list methods.
   */
  private <T> List<T> queryList(String sql, ResultSetMapper<T> mapper, Object... params) throws SQLException {
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      for (int i = 0; i < params.length; i++) {
        ps.setObject(i + 1, params[i]);
      }
      try (ResultSet rs = ps.executeQuery()) {
        List<T> result = new ArrayList<>();
        while (rs.next()) {
          result.add(mapper.map(rs));
        }
        return result;
      }
    }
  }

  public List<Chip> listChips(long lessonRefId) throws SQLException {
    String sql = "SELECT c.chip_id, ct.code AS chip_type_code, c.title, c.content_md "
      + "FROM chips c JOIN chip_types ct ON ct.chip_type_id=c.chip_type_id "
      + "WHERE c.lesson_ref_id=? ORDER BY c.chip_id";
    return queryList(sql, rs -> new Chip(
      rs.getLong("chip_id"),
      rs.getString("chip_type_code"),
      rs.getString("title"),
      rs.getString("content_md")
    ), lessonRefId);
  }

  public List<Rule> listRules(long lessonRefId) throws SQLException {
    String sql = "SELECT r.rule_id, rt.code AS rule_type_code, lr.importance_id, il.code AS importance_code, r.title, r.statement_md, "
      + "r.pattern_json, r.notes_md "
      + "FROM lesson_rules lr "
      + "JOIN rules r ON r.rule_id=lr.rule_id "
      + "JOIN rule_types rt ON rt.rule_type_id=r.rule_type_id "
      + "LEFT JOIN importance_levels il ON il.importance_id=lr.importance_id "
      + "WHERE lr.lesson_ref_id=? "
      + "ORDER BY lr.importance_id, r.rule_id";
    return queryList(sql, rs -> {
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
      return new Rule(
        rs.getLong("rule_id"),
        rs.getString("rule_type_code"),
        rs.getString("title"),
        rs.getString("statement_md"),
        pattern,
        rs.getString("notes_md"),
        (Integer) rs.getObject("importance_id"),
        rs.getString("importance_code")
      );
    }, lessonRefId);
  }

  public List<Example> listExamples(long lessonRefId) throws SQLException {
    String sql = "SELECT example_id, kg_text, fr_text, en_text, notes_md "
      + "FROM examples WHERE lesson_ref_id=? ORDER BY example_id";
    return queryList(sql, rs -> new Example(
      rs.getLong("example_id"),
      rs.getString("kg_text"),
      rs.getString("fr_text"),
      rs.getString("en_text"),
      rs.getString("notes_md")
    ), lessonRefId);
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
    return queryList(sql, rs -> new Atom(
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
    ), lessonRefId);
  }

  public List<String> getAtomGraphemeSeq(long atomId, long orthographyId) throws SQLException {
    String sql = "SELECT ags.seq, g.grapheme "
      + "FROM atom_grapheme_seq ags "
      + "JOIN graphemes g ON g.grapheme_id=ags.grapheme_id "
      + "WHERE ags.atom_id=? AND ags.orthography_id=? "
      + "ORDER BY ags.seq";
    return queryList(sql, rs -> rs.getString("grapheme"), atomId, orthographyId);
  }

  public List<AtomTag> listAtomTags(long atomId) throws SQLException {
    String sql = "SELECT tg.scope, tg.code, tg.label_fr, tg.description_md "
      + "FROM atom_tags atg JOIN tags tg ON tg.tag_id=atg.tag_id "
      + "WHERE atg.atom_id=? ORDER BY tg.scope, tg.code";
    return queryList(sql, rs -> new AtomTag(
      rs.getString("scope"),
      rs.getString("code"),
      rs.getString("label_fr"),
      rs.getString("description_md")
    ), atomId);
  }

  public List<AtomGloss> listAtomGlosses(long atomId) throws SQLException {
    String sql = "SELECT language_code, gloss, notes_md FROM atom_glosses WHERE atom_id=? ORDER BY language_code";
    return queryList(sql, rs -> new AtomGloss(
      rs.getString("language_code"),
      rs.getString("gloss"),
      rs.getString("notes_md")
    ), atomId);
  }

  public List<AtomSourceRef> listAtomSources(long atomId) throws SQLException {
    String sql = "SELECT s.source_id, s.code AS source_code, s.title, s.authors, s.year, s.publisher, s.isbn, s.url, "
      + "s.language_code, asrc.ref, asrc.quote_md, asrc.comment_md "
      + "FROM atom_sources asrc JOIN sources s ON s.source_id=asrc.source_id "
      + "WHERE asrc.atom_id=? ORDER BY s.source_id";
    return queryList(sql, rs -> new AtomSourceRef(
      rs.getLong("source_id"),
      rs.getString("source_code"),
      rs.getString("title"),
      rs.getString("authors"),
      (Integer) rs.getObject("year"),
      rs.getString("publisher"),
      rs.getString("isbn"),
      rs.getString("url"),
      rs.getString("language_code"),
      rs.getString("ref"),
      rs.getString("quote_md"),
      rs.getString("comment_md")
    ), atomId);
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
    
    List<Object> params = new ArrayList<>();
    params.addAll(atomIds);
    params.addAll(atomIds);
    
    return queryList(sql, rs -> new AtomRelation(
      rs.getLong("from_atom_id"),
      rs.getLong("to_atom_id"),
      rs.getString("relation_type_code"),
      rs.getString("notes_md")
    ), params.toArray());
  }

  /**
   * Batch-load grapheme sequences for multiple atoms (eliminates N+1 query problem).
   * Returns a map of atomId -> list of graphemes.
   */
  private Map<Long, List<String>> batchLoadGraphemeSeqs(List<Long> atomIds, long orthographyId) throws SQLException {
    if (atomIds == null || atomIds.isEmpty()) {
      return Collections.emptyMap();
    }
    
    String in = atomIds.stream().map(x -> "?").collect(Collectors.joining(","));
    String sql = "SELECT ags.atom_id, ags.seq, g.grapheme "
      + "FROM atom_grapheme_seq ags "
      + "JOIN graphemes g ON g.grapheme_id=ags.grapheme_id "
      + "WHERE ags.atom_id IN (" + in + ") AND ags.orthography_id=? "
      + "ORDER BY ags.atom_id, ags.seq";
    
    Map<Long, List<String>> result = new LinkedHashMap<>();
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      int idx = 1;
      for (Long id : atomIds) {
        ps.setLong(idx++, id);
      }
      ps.setLong(idx, orthographyId);
      
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          long atomId = rs.getLong("atom_id");
          result.computeIfAbsent(atomId, k -> new ArrayList<>()).add(rs.getString("grapheme"));
        }
      }
    }
    return result;
  }

  /**
   * Batch-load tags for multiple atoms (eliminates N+1 query problem).
   * Returns a map of atomId -> list of tags.
   */
  private Map<Long, List<AtomTag>> batchLoadTags(List<Long> atomIds) throws SQLException {
    if (atomIds == null || atomIds.isEmpty()) {
      return Collections.emptyMap();
    }
    
    String in = atomIds.stream().map(x -> "?").collect(Collectors.joining(","));
    String sql = "SELECT atg.atom_id, tg.scope, tg.code, tg.label_fr, tg.description_md "
      + "FROM atom_tags atg JOIN tags tg ON tg.tag_id=atg.tag_id "
      + "WHERE atg.atom_id IN (" + in + ") ORDER BY atg.atom_id, tg.scope, tg.code";
    
    Map<Long, List<AtomTag>> result = new LinkedHashMap<>();
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      int idx = 1;
      for (Long id : atomIds) {
        ps.setLong(idx++, id);
      }
      
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          long atomId = rs.getLong("atom_id");
          result.computeIfAbsent(atomId, k -> new ArrayList<>()).add(new AtomTag(
            rs.getString("scope"),
            rs.getString("code"),
            rs.getString("label_fr"),
            rs.getString("description_md")
          ));
        }
      }
    }
    return result;
  }

  /**
   * Batch-load glosses for multiple atoms (eliminates N+1 query problem).
   * Returns a map of atomId -> list of glosses.
   */
  private Map<Long, List<AtomGloss>> batchLoadGlosses(List<Long> atomIds) throws SQLException {
    if (atomIds == null || atomIds.isEmpty()) {
      return Collections.emptyMap();
    }
    
    String in = atomIds.stream().map(x -> "?").collect(Collectors.joining(","));
    String sql = "SELECT atom_id, language_code, gloss, notes_md "
      + "FROM atom_glosses WHERE atom_id IN (" + in + ") ORDER BY atom_id, language_code";
    
    Map<Long, List<AtomGloss>> result = new LinkedHashMap<>();
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      int idx = 1;
      for (Long id : atomIds) {
        ps.setLong(idx++, id);
      }
      
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          long atomId = rs.getLong("atom_id");
          result.computeIfAbsent(atomId, k -> new ArrayList<>()).add(new AtomGloss(
            rs.getString("language_code"),
            rs.getString("gloss"),
            rs.getString("notes_md")
          ));
        }
      }
    }
    return result;
  }

  /**
   * Batch-load sources for multiple atoms (eliminates N+1 query problem).
   * Returns a map of atomId -> list of source references.
   */
  private Map<Long, List<AtomSourceRef>> batchLoadSources(List<Long> atomIds) throws SQLException {
    if (atomIds == null || atomIds.isEmpty()) {
      return Collections.emptyMap();
    }
    
    String in = atomIds.stream().map(x -> "?").collect(Collectors.joining(","));
    String sql = "SELECT asrc.atom_id, s.source_id, s.code AS source_code, s.title, s.authors, s.year, "
      + "s.publisher, s.isbn, s.url, s.language_code, asrc.ref, asrc.quote_md, asrc.comment_md "
      + "FROM atom_sources asrc JOIN sources s ON s.source_id=asrc.source_id "
      + "WHERE asrc.atom_id IN (" + in + ") ORDER BY asrc.atom_id, s.source_id";
    
    Map<Long, List<AtomSourceRef>> result = new LinkedHashMap<>();
    try (PreparedStatement ps = cx.prepareStatement(sql)) {
      int idx = 1;
      for (Long id : atomIds) {
        ps.setLong(idx++, id);
      }
      
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          long atomId = rs.getLong("atom_id");
          result.computeIfAbsent(atomId, k -> new ArrayList<>()).add(new AtomSourceRef(
            rs.getLong("source_id"),
            rs.getString("source_code"),
            rs.getString("title"),
            rs.getString("authors"),
            (Integer) rs.getObject("year"),
            rs.getString("publisher"),
            rs.getString("isbn"),
            rs.getString("url"),
            rs.getString("language_code"),
            rs.getString("ref"),
            rs.getString("quote_md"),
            rs.getString("comment_md")
          ));
        }
      }
    }
    return result;
  }

  /**
   * Enriches atoms with their metadata (grapheme sequences, tags, sources, glosses).
   * Uses batch loading to avoid N+1 query problem.
   */
  private void enrichAtomsWithMetadata(List<Atom> atoms, long orthographyId) throws SQLException {
    if (atoms == null || atoms.isEmpty()) {
      return;
    }
    
    List<Long> atomIds = atoms.stream().map(Atom::getAtomId).collect(Collectors.toList());
    
    // Batch load all metadata
    Map<Long, List<String>> graphemeSeqs = batchLoadGraphemeSeqs(atomIds, orthographyId);
    Map<Long, List<AtomTag>> tags = batchLoadTags(atomIds);
    Map<Long, List<AtomGloss>> glosses = batchLoadGlosses(atomIds);
    Map<Long, List<AtomSourceRef>> sources = batchLoadSources(atomIds);
    
    // Populate each atom with its metadata
    for (Atom atom : atoms) {
      long atomId = atom.getAtomId();
      atom.getGraphemeSeq().addAll(graphemeSeqs.getOrDefault(atomId, Collections.emptyList()));
      atom.getTags().addAll(tags.getOrDefault(atomId, Collections.emptyList()));
      atom.getGlosses().addAll(glosses.getOrDefault(atomId, Collections.emptyList()));
      atom.getSources().addAll(sources.getOrDefault(atomId, Collections.emptyList()));
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
    // Use batch loading instead of N+1 queries
    enrichAtomsWithMetadata(atoms, orthographyId);
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
