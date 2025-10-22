# ReceiptFlow

## Proposta
O ReceiptFlow é uma aplicação web desenvolvida em Ruby on Rails que visa facilitar a gestão e o compartilhamento de recibos entre usuários. A plataforma permite que os usuários façam upload, visualizem e compartilhem recibos de maneira eficiente, promovendo a organização financeira pessoal e empresarial.

## Integrantes

| Nome                                 | Número USP |
|--------------------------------------|------------|
| André Vieira Rocha                   | 12681611   |
| Gabriel Dimant                       | 14653248   |
| Gabriel Monteiro de Souza            | 14746450   |
| Gabriela Pinheiro Almeida Dantas     | 14573249   |
| Ricardo Miranda Cordovil Filho       | 14658257   |
| Matheus Silva Lopes da Costa         | 12674680   |

<!--
## Badges
#### Branch Dev
![Dev Branch](https://github.com/SirMonteiro/heatmapp/actions/workflows/blank.yml/badge.svg?branch=dev)

#### Branch Master
![Master Branch](https://github.com/SirMonteiro/heatmapp/actions/workflows/blank.yml/badge.svg?branch=main)-->

#### Qlty.sh Badges
[![Maintainability](https://qlty.sh/gh/SirMonteiro/projects/ReceiptFlow/maintainability.svg)](https://qlty.sh/gh/SirMonteiro/projects/ReceiptFlow)
[![Code Coverage](https://qlty.sh/gh/SirMonteiro/projects/ReceiptFlow/coverage.svg)](https://qlty.sh/gh/SirMonteiro/projects/ReceiptFlow)

## Running the Project Locally

To run this project locally, follow the steps below:

### Prerequisites

Ensure you have [Mise](https://mise.jdx.dev/) installed on your system. Mise is a tool for managing project environments and dependencies.

In case you don't have Mise installed, you can follow setup environment instructions.

### Steps

1. **Install the Required Ruby Version**
   Use Mise to install the Ruby version specified in the `mise.toml` file:
  ```bash
  mise run install
  ```
2. Install Project Dependencies**
  Once the correct Ruby version is installed, install the required gems:
  ```bash
  mise run bundle:install
  ```

3. **Run Pre-Boot Functions**
  Before starting the server, ensure the database is set up and migrations are applied:
  ```bash
  mise run db:prepare
  ```

4. **Start the Server**
  Run the Rails server:
  ```bash
  mise start
  ```

5. **Access the Application**
  Open your browser and navigate to `http://localhost:3000` to view the application.

---

## Running Tests and Measuring Coverage

This project uses RSpec for unit and functional tests, Jasmine for JavaScript tests, and Cucumber with Capybara for user story tests. Follow these steps to run tests and measure coverage:

### Running RSpec Tests
Run the RSpec tests to ensure the backend functionality is working as expected:
```bash
mise run test:unit
```

### Running Cucumber Tests
Run the Cucumber tests to validate user stories:
```bash
mise run test:integration
```

### Running JavaScript Tests
Run the Jasmine tests for JavaScript functionality:
```bash
bundle run jasmine
```

### Measuring Test Coverage
This project uses Coveralls to measure test coverage. To generate a local coverage report:
```bash
COVERAGE=true bundle run spec
```
The coverage report will be available in the `coverage/` directory.

---

## Code Quality and Static Analysis

This project uses Qlty to measure code quality and identify potential issues. Ensure your code adheres to the quality standards by running:
```bash
mise run lint
```

## Setup development environment

To set up the development environment, follow these steps:

1. **Install Mise**:

```bash
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
```
