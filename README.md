# COMP3311 24T1 Assignment 1 Automarker - Setup and Usage Guide

Welcome to the Automarker system! This README will guide you through the process of setting up the Automarker environment and using it to compare your assignment outputs. Follow these steps to get started.

## Initial Setup

Before using the Automarker, please complete the following setup steps:

### 1. Clone the Repository

First, clone the repository to your local machine. This will create a copy of the Automarker system in your chosen directory. Open your terminal and run:

```bash
git clone git@github.com:keraan/COMP3311-24T1-Assignment-1-Automarker.git
```

### 2. Copy Your Assignment File

Next, you need to copy your `ass1.sql` file into the cloned repository directory. This file contains the SQL queries you've written and wish to test with the Automarker. You can do this by running:

```bash
cp /path/to/your/ass1.sql /path/to/cloned/repository
```

Make sure to replace `/path/to/your/ass1.sql` with the actual path to your assignment file and `/path/to/cloned/repository` with the path to the cloned repository directory.

### 3. Make the Script Executable

The Automarker relies on a Bash script named `compare_outputs.sh` to function. You must make this script executable with the following command:

```bash
chmod +x compare_outputs.sh
```

Navigate to the repository directory in your terminal before running this command.

## Usage Instructions

Once you have completed the one-time setup, follow these steps each time you want to use the Automarker to compare outputs.

### Start Your Server

1. **Initialize Your Environment**:

   Before starting the server, you need to initialize your environment by sourcing the environment file located at `/localstorage/$USER/env`. Run:

   ```bash
   source /localstorage/$USER/env
   ```

2. **Start the Server**:

   After setting up your environment, start the server by running:

   ```bash
   p1
   ```

### Compare Outputs

To compare your assignment outputs using the Automarker, execute the `compare_outputs.sh` script followed by the question number you want to compare. For example:

```bash
./compare_outputs.sh question_number
```

Replace `question_number` with the actual number of the question you're testing.

Currently, the automarker is only updated to support questions 1-7. (Q8, Q9, Q10 not yet supported).

## Conclusion

You're all set! By following these setup and usage instructions, you should be able to efficiently use the Automarker system to compare your assignment outputs. If you encounter any issues, please refer back to this README for guidance.
