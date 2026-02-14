package com.longoka.games.app;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.longoka.games.factory.model.LessonPack;
import com.longoka.games.factory.repo.FactoryLessonRepository;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.sql.Connection;
import java.time.OffsetDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Export a lesson (chips + rules + examples + atoms...) as a single JSON pack.
 *
 * Usage:
 * mvn -q -DskipTests package
 * java -cp target/backend-java-1.0-SNAPSHOT-jar-with-dependencies.jar \
 * com.longoka.games.app.FactoryLessonPackJsonExportTool \
 * --course 3 --lesson 9 --out /tmp/lesson-3-9.json
 *
 * DB config (either via properties file already used by DbConfig OR env vars):
 * FACTORY_DB_HOST, FACTORY_DB_PORT, FACTORY_DB_NAME, FACTORY_DB_USER,
 * FACTORY_DB_PASS
 */
public class FactoryLessonPackJsonExportTool {

  public static void main(String[] args) throws Exception {
    Map<String, String> a = parseArgs(args);

    int courseId = Integer.parseInt(require(a, "course"));
    int lessonId = Integer.parseInt(require(a, "lesson"));
    String outPath = a.get("out");

    ObjectMapper mapper = new ObjectMapper()
        .findAndRegisterModules()
        .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)
        .enable(SerializationFeature.INDENT_OUTPUT);

    try (Connection conn = DbConfig.openFactoryConnection()) {
      FactoryLessonRepository repo = new FactoryLessonRepository(conn, mapper);
      LessonPack pack = repo.exportLessonPack(courseId, lessonId);

      // minimal meta
      pack.getMeta().put("exported_at", OffsetDateTime.now().toString());
      pack.getMeta().put("course_id", courseId);
      pack.getMeta().put("lesson_id", lessonId);

      String json = mapper.writeValueAsString(pack);

      if (outPath == null || outPath.isBlank()) {
        System.out.println(json);
        return;
      }

      File out = new File(outPath);
      if (out.getParentFile() != null) {
        out.getParentFile().mkdirs();
      }
      Files.writeString(out.toPath(), json, StandardCharsets.UTF_8);
      System.out.println("OK: wrote " + out.getAbsolutePath());
    }
  }

  private static Map<String, String> parseArgs(String[] args) {
    Map<String, String> map = new HashMap<>();
    for (int i = 0; i < args.length; i++) {
      String tok = args[i];
      if (!tok.startsWith("--"))
        continue;
      String key = tok.substring(2);
      String val = "true";
      if (i + 1 < args.length && !args[i + 1].startsWith("--")) {
        val = args[i + 1];
        i++;
      }
      map.put(key, val);
    }
    return map;
  }

  private static String require(Map<String, String> args, String key) {
    String v = args.get(key);
    if (v == null || v.isBlank()) {
      throw new IllegalArgumentException("Missing --" + key);
    }
    return v;
  }
}
