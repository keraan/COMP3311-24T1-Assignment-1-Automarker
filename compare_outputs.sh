#!/bin/bash

# Directory containing expected output files
# This is the directory containing the expected output files e.g /path/to/expected_outputs
expected_output_dir="expected_outputs"

# This is the question you want to test
current_question=7

# DO NOT TOUCH
current_dump_index=1
your_database="i"
sql_file="ass1.sql"
dump_files=("IMDB.dump.1.sql" "IMDB.dump.2.sql" "IMDB.dump.3.sql" "IMDB.dump.4.sql" "IMDB.dump.5.sql")

q5d1_inputs=("Day" "Free" "Son" "20")
q5d2_inputs=("20" "Sea" "Lost" "aa")
q5d3_inputs=("Ghost" "Home" "20" "neo")
q5d4_inputs=("Cat" "cat" "Dog" "dog")
q5d5_inputs=("Comp" "Life" "Earth" "Sun")

q6d1_inputs=("Comedy" "Drama" "Action" "Horror")
q6d2_inputs=("Horror" "Documentary" "Comedy")
q6d3_inputs=("Comedy" "Drama" "Sci-Fi")
q6d4_inputs=("Documentary" "Horror" "Mystery")
q6d5_inputs=("Music" "Drama" "Documentary")

q7d1_inputs=("Butterfly" "Sorcerer" "Flukten Fra Juleserveren!: The Movie" "Sweetheart" "Jake and the Giants" "Asterix: The Secret of the Magic Potion")
q7d2_inputs=("El hombre de los hongos" "Neon Genesis Evangelion: Girlfriend of Steel" "Cheaters" "The New Adventures of Max" "DC League of Super-Pets" "Don Quixote, Knight Errant")
q7d3_inputs=("The Queen of Hearts" "Diary of a Demon" "The Seventh Sin" "Passage to Mars" "Oracles of Pennsylvania Avenue" "Chikan densha: Misemasu kyonyû")
q7d4_inputs=("Äl'' yli päästä perhanaa" "The Underground Comedy Movie" "William S. Burroughs Birthday Bash" "The Legend of Zelda: A Link to the Past" "4th Wall Players Presents: The Importance of Being Earnest" "Disconnection Notice")
q7d5_inputs=("The Meaning of Life" "The Defense of New Haven" "Return of the Left-Handed Man" "Galaxy Lords" "Or So I''ve Been Told" "This Loneliness")

function compare_differences() {
    diff_output=$(diff -w "diff.txt" "$1")

    # Check for differences
    if [ -z "$diff_output" ]; then
        echo "$base_name: No differences found."
    else
        echo "$base_name: Differences found."
        # Optionally, you can show the differences
        diff -w diff.txt "$1"
    fi
}


# Loops over every dump file
for dump_file in "${dump_files[@]}"; do
    if [ ! -f "$sql_file" ]; then
        echo "SQL file for $sql_file does not exist. "
        continue
    fi
    # Drop and recreate the database
    dropdb "$your_database" > /dev/null 2>&1
    createdb "$your_database" > /dev/null 2>&1
    psql -d "$your_database" -f "$dump_file" > /dev/null 2>&1
    psql "$your_database" -f "$sql_file" > /dev/null 2>&1

    for expected_output in "$expected_output_dir"/*.txt; do 
        base_name=$(basename "$expected_output" .txt)

        # Find the correct expected output file
        filename=$(basename "$expected_output")
        dump_identifier="${filename%.*}"  # Remove the extension
        dump_identifier="${dump_identifier: -2}"  # Get the last two characters, e.g., 'd1'
        expected_dump_index="d$current_dump_index"
        if [ "$dump_identifier" != "$expected_dump_index" ]; then
            continue
        fi

        filename=$(basename "$expected_output")
        question_identifier="${filename%.*}"  # Remove the extension
        question_identifier="${question_identifier:0:2}"  # Get the first two characters, e.g., 'q1'
        expected_question_index="q$current_question"
        if [ "$question_identifier" != "$expected_question_index" ]; then
            continue
        fi

        echo "Comparing $base_name"

        if [ "$current_question" > 4 ]; then
            inputs_name="q${current_question}d${current_dump_index}_inputs[@]"
            inputs=("${!inputs_name}")
            current_array_index=0
            for input in "${inputs[@]}"; do
                # echo "Input: $input"
                query="SELECT * FROM Q${current_question}('$input')"
                echo "$query"
                # echo "basename $base_name"
                psql -d "$your_database" -c "\copy ($query) TO 'diff.txt' WITH (FORMAT text)"
                # If you're intending to write to a file in the expected_outputs directory
                
                #psql -d "$your_database" -c "\copy ($query) TO './expected_outputs/${base_name}v${current_array_index}.txt' WITH (FORMAT text)"

                compare_differences "./expected_outputs/${base_name}v${current_array_index}.txt"

                current_array_index=$((current_array_index + 1))
            done
        else
            psql -d "$your_database" -c "\copy (SELECT * FROM Q$current_question) TO 'diff.txt' WITH (FORMAT text)"
        fi

    done

    echo

    current_dump_index=$((current_dump_index + 1))

done
