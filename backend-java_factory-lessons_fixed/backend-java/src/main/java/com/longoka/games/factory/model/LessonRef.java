package com.longoka.games.factory.model;

import java.time.LocalDateTime;

public class LessonRef {

  private final long lessonRefId;
  private final int platformId;
  private final int courseId;
  private final int lessonId;
  private final Integer position;
  private final String lessonGroup;
  private final String slug;
  private final String title;
  private final String status;
  private final String visibility;
  private final LocalDateTime createdAt;
  private final LocalDateTime updatedAt;

  public LessonRef(
      long lessonRefId,
      int platformId,
      int courseId,
      int lessonId,
      Integer position,
      String lessonGroup,
      String slug,
      String title,
      String status,
      String visibility,
      LocalDateTime createdAt,
      LocalDateTime updatedAt) {
    this.lessonRefId = lessonRefId;
    this.platformId = platformId;
    this.courseId = courseId;
    this.lessonId = lessonId;
    this.position = position;
    this.lessonGroup = lessonGroup;
    this.slug = slug;
    this.title = title;
    this.status = status;
    this.visibility = visibility;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  public long getLessonRefId() {
    return lessonRefId;
  }

  public int getPlatformId() {
    return platformId;
  }

  public int getCourseId() {
    return courseId;
  }

  public int getLessonId() {
    return lessonId;
  }

  public Integer getPosition() {
    return position;
  }

  public String getLessonGroup() {
    return lessonGroup;
  }

  public String getSlug() {
    return slug;
  }

  public String getTitle() {
    return title;
  }

  public String getStatus() {
    return status;
  }

  public String getVisibility() {
    return visibility;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }
}
