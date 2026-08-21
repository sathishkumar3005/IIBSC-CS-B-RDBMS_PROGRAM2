#!/bin/bash

MYSQL="mysql -h127.0.0.1 -P3306 -uroot -proot"

echo "========================================"
echo " Student Table SQL Assignment"
echo "========================================"

if [ ! -f "student_solution.sql" ]; then
    echo "FAIL: student_solution.sql file not found."
    exit 1
fi

echo "Creating fresh CollegeDB database..."

$MYSQL -e "DROP DATABASE IF EXISTS CollegeDB;"
$MYSQL -e "CREATE DATABASE CollegeDB;"

echo "Executing student_solution.sql..."

# Execute SQL and capture errors
if ! $MYSQL CollegeDB < student_solution.sql; then
    echo ""
    echo "FAIL: Error while executing student_solution.sql"
    echo "Please check your SQL syntax."
    exit 1
fi

echo ""
echo "Checking Student table..."

TABLE=$($MYSQL -N -s CollegeDB -e "
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student';")

if [ "$TABLE" != "Student" ]; then
    echo "FAIL: Student table was not created."
    echo ""
    echo "Tables currently found:"
    $MYSQL CollegeDB -e "SHOW TABLES;"
    exit 1
fi

echo "PASS: Student table created."

MARKS=2

# Test Case 1 - StudentID
RESULT=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='StudentID';")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: StudentID exists."
    MARKS=$((MARKS + 1))
else
    echo "FAIL: StudentID missing."
fi

# Test Case 2 - StudentName
RESULT=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='StudentName';")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: StudentName exists."
    MARKS=$((MARKS + 1))
else
    echo "FAIL: StudentName missing."
fi

# Test Case 3 - DOB
RESULT=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='DOB'
AND DATA_TYPE='date';")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: DOB exists with DATE datatype."
    MARKS=$((MARKS + 1))
else
    echo "FAIL: DOB missing or datatype is incorrect."
fi

# Test Case 4 - Gender
RESULT=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='Gender';")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: Gender exists."
    MARKS=$((MARKS + 1))
else
    echo "FAIL: Gender missing."
fi

# Test Case 5 - DepartmentID
RESULT=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='DepartmentID';")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: DepartmentID exists."
    MARKS=$((MARKS + 1))
else
    echo "FAIL: DepartmentID missing."
fi

# Test Case 6 - Primary Key
RESULT=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND CONSTRAINT_NAME='PRIMARY'
AND COLUMN_NAME='StudentID';")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: StudentID is Primary Key."
    MARKS=$((MARKS + 1))
else
    echo "FAIL: StudentID is not Primary Key."
fi

# Test Case 7 - UNIQUE
RESULT=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND NON_UNIQUE=0
AND INDEX_NAME <> 'PRIMARY';")

if [ "$RESULT" -ge 1 ]; then
    echo "PASS: UNIQUE constraint exists."
    MARKS=$((MARKS + 1))
else
    echo "FAIL: UNIQUE constraint missing."
fi

# Test Case 8 - NOT NULL
RESULT=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND IS_NULLABLE='NO';")

if [ "$RESULT" -ge 4 ]; then
    echo "PASS: NOT NULL constraints exist."
    MARKS=$((MARKS + 1))
else
    echo "FAIL: Required NOT NULL constraints missing."
fi

echo ""
echo "========================================"
echo "Total Marks: $MARKS / 10"
echo "========================================"

if [ "$MARKS" -eq 10 ]; then
    echo "SUCCESS: All test cases passed."
    exit 0
else
    echo "Some test cases failed."
    exit 1
fi
