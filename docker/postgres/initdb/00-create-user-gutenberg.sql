-- Create the gutenberg user
CREATE USER gutenberg WITH PASSWORD 'gutenberg_password';

-- Grant all privileges on the gutenberg database to the gutenberg user
GRANT ALL PRIVILEGES ON DATABASE gutenberg TO gutenberg;
