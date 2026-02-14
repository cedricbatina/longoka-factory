package com.longoka.games.factory.repo;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Functional interface for mapping a ResultSet row to a domain object.
 * Extracted to reduce boilerplate in repository query methods.
 */
@FunctionalInterface
public interface ResultSetMapper<T> {
  /**
   * Map the current row of the ResultSet to an instance of T.
   * 
   * @param rs the ResultSet positioned at the current row
   * @return the mapped object
   * @throws SQLException if an error occurs reading from the ResultSet
   */
  T map(ResultSet rs) throws SQLException;
}
