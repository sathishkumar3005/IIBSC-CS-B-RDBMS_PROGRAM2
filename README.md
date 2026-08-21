 Student Table

## Objective

Create a `Student` table using SQL and apply appropriate constraints.

## Problem Statement

Create a table named `Student` with the following fields:

| Field Name | Data Type | Constraint |
|---|---|---|
| StudentID | INT(5) | PRIMARY KEY |
| StudentName | VARCHAR(20) | NOT NULL |
| DOB | DATE | NOT NULL |
| Gender | VARCHAR(10) | NOT NULL |
| DepartmentID | INT(5) | NOT NULL |

You must also add an appropriate `UNIQUE` constraint.

## Instructions

1. Open the file `student_solution.sql`.
2. Write the SQL statement to create the `Student` table.
3. Add the required constraints:
   - PRIMARY KEY
   - UNIQUE
   - NOT NULL
4. Do not rename `student_solution.sql`.
5. Commit and push your changes to GitHub.
6. GitHub Actions will automatically test your SQL.

## Important

This assignment uses MySQL.

Use:

```sql
INT(5)
```

instead of:

```sql
NUMBER(5)
```

because `NUMBER(5)` is an Oracle datatype.

## Marks Distribution

| Test | Marks |
|---|---:|
| Student table created | 2 |
| StudentID exists | 1 |
| StudentName exists | 1 |
| DOB is DATE | 1 |
| Gender exists | 1 |
| DepartmentID exists | 1 |
| StudentID Primary Key | 1 |
| UNIQUE constraint | 1 |
| NOT NULL constraints | 1 |
| **Total** | **10** |

## Submission

Submit only your completed:

```text
student_solution.sql
```

Do not modify the autograding files.
