CREATE USER vereinAdmin WITH LOGIN PASSWORD 'root';

CREATE DATABASE fussballVerein OWNER vereinAdmin;
GRANT ALL PRIVILEGES ON DATABASE fussballVerein TO vereinAdmin;
