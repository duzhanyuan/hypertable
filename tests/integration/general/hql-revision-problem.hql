CREATE NAMESPACE revision_problem;
USE revision_problem;
DROP TABLE IF EXISTS www;
CREATE TABLE www (
  size MAX_VERSIONS 1
);
INSERT INTO www VALUES
  ("2016-04-10 02:46:55.892228825", "row01", "size:content", "70772"),
  ("2016-04-11 02:43:21.605421596", "row01", "size:content", "70772");
SELECT size FROM www WHERE CELL="row01","size:content" DISPLAY_TIMESTAMPS;
SELECT size FROM www WHERE CELL="row01","size:content" and TIMESTAMP < "2016-04-11 00:00:00" DISPLAY_TIMESTAMPS;
