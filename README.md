# GPG Key Generation and GitHub Integration Script

This repository hosts a Bash script, `git_signing_key.sh`, designed to automate the generation of a GPG (GNU Privacy Guard) key for Git commit signing and its subsequent upload to a GitHub account. This script streamlines the process of setting up GPG signing for your Git commits, enhancing the security and verification of your contributions.

## Features

- Checks for necessary dependencies (`openssl`, `gpg`, `gh` CLI).
- Generates a secure random passphrase for the GPG key.
- Creates a GPG key with user-defined parameters.
- Configures Git to use the newly generated GPG key for commit and tag signing.
- Uploads the GPG public key to the user's GitHub account.

## Prerequisites

Before running the script, ensure you have the following installed on your system:

- `openssl`: For generating a secure passphrase.
- `gpg`: For creating the GPG key.
- `gh`: GitHub CLI, for uploading the GPG key to GitHub.
- A running `gpg-agent`: Required for managing GPG key operations.

## Usage

1. **Clone the Repository**

   ```bash
   git clone https://github.com/AndresCdo/gpg-key-automation.git
   ```

2. **Navigate to the Repository Directory**

   ```bash
    cd gpg-key-automation
    ```

3. **Run the Script**

   ```bash
   bash git_signing_key.sh
   ```

4. **Follow the On-Screen Instructions**

    The script will guide you through the process of setting up your GPG key and integrating it with your GitHub account.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [GitHub CLI](https://cli.github.com/) for providing a seamless way to interact with GitHub from the command line.

