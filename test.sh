#!/bin/bash

MYSQL="mysql -h127.0.0.1 -P3306 -uroot -proot -N -s"

echo "========================================"
echo " Student Table SQL Assignment"
echo "========================================"

# Check whether student_solution.sql exists
if [ ! -f "student_solution.sql" ]; then
    echo "ERROR: student_solution.sql file not found."
    exit 1
fi

# Create a fresh database for testing
mysql -h127.0.0.1 -P3306 -uroot -proot -e "DROP DATABASE IF EXISTS CollegeDB;"
mysql -h127.0.0.1 -P3306 -uroot -proot -e "CREATE DATABASE CollegeDB;"

echo "Executing student_solution.sql..."

# Execute student's SQL inside CollegeDB
mysql -h127.0.0.1 -P3306 -uroot -proot CollegeDB < student_solution.sql

# Check whether Student table exists
TABLE=$($MYSQL CollegeDB -e "SHOW TABLES LIKE 'Student';")

if [ "$TABLE" != "Student" ]; then
    echo "FAIL: Student table was not created."
    exit 1
fi

echo "PASS: Student table created."

MARKS=2

# Test Case 1: StudentID exists
COLUMN=$($MYSQL CollegeDB -e "
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='StudentID';")

if [ "$COLUMN" = "StudentID" ]; then
    echo "PASS: StudentID column exists."
    MARKS=$((MARKS+1))
else
    echo "FAIL: StudentID column missing."
fi

# Test Case 2: StudentName exists
COLUMN=$($MYSQL CollegeDB -e "
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='StudentName';")

if [ "$COLUMN" = "StudentName" ]; then
    echo "PASS: StudentName column exists."
    MARKS=$((MARKS+1))
else
    echo "FAIL: StudentName column missing."
fi

# Test Case 3: DOB exists and is DATE
TYPE=$($MYSQL CollegeDB -e "
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='DOB';")

if [ "$TYPE" = "date" ]; then
    echo "PASS: DOB column is DATE."
    MARKS=$((MARKS+1))
else
    echo "FAIL: DOB column is missing or datatype is incorrect."
fi

# Test Case 4: Gender exists
COLUMN=$($MYSQL CollegeDB -e "
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='Gender';")

if [ "$COLUMN" = "Gender" ]; then
    echo "PASS: Gender column exists."
    MARKS=$((MARKS+1))
else
    echo "FAIL: Gender column missing."
fi

# Test Case 5: DepartmentID exists
COLUMN=$($MYSQL CollegeDB -e "
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='DepartmentID';")

if [ "$COLUMN" = "DepartmentID" ]; then
    echo "PASS: DepartmentID column exists."
    MARKS=$((MARKS+1))
else
    echo "FAIL: DepartmentID column missing."
fi

# Test Case 6: StudentID is Primary Key
PK=$($MYSQL CollegeDB -e "
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND CONSTRAINT_NAME='PRIMARY'
AND COLUMN_NAME='StudentID';")

if [ "$PK" = "StudentID" ]; then
    echo "PASS: StudentID is Primary Key."
    MARKS=$((MARKS+1))
else
    echo "FAIL: StudentID is not Primary Key."
fi

# Test Case 7: UNIQUE constraint exists
UNIQUE_COL=$($MYSQL CollegeDB -e "
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND NON_UNIQUE=0
AND INDEX_NAME <> 'PRIMARY'
LIMIT 1;")

if [ -n "$UNIQUE_COL" ]; then
    echo "PASS: UNIQUE constraint exists."
    MARKS=$((MARKS+1))
else
    echo "FAIL: UNIQUE constraint not found."
fi

# Test Case 8: NOT NULL constraints
NOT_NULL_COUNT=$($MYSQL CollegeDB -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND IS_NULLABLE='NO';")

if [ "$NOT_NULL_COUNT" -ge 4 ]; then
    echo "PASS: Appropriate NOT NULL constraints exist."
    MARKS=$((MARKS+1))
else
    echo "FAIL: Required NOT NULL constraints are missing."
fi

echo ""
echo "========================================"
echo " Total Marks: $MARKS / 10"
echo "========================================"

if [ "$MARKS" -eq 10 ]; then
    echo "All tests passed!"
    exit 0
else
    echo "Some tests failed."
    exit 1
fi
