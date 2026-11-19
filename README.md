# Testes Automatizados — Sistema Hospitalar (Robot Framework)

Automação de testes para a aplicação **Sistema Hospitalar** utilizando **Robot Framework**.

## Integrantes
- Davi Kauã
- Hyago Kesser
- Vinicius Lira Hansen

## Recursos Utilizados
- **Browser Library (Playwright):** testes Web E2E, validação HTML5, viewport mobile e screenshots automáticos.
- **RequestsLibrary:** testes diretos nas rotas HTTP (`200`, `302`, `404` e `500`).
- **Process + `__init__.robot`:** inicia e encerra o servidor Node.js automaticamente antes e depois da suíte.
- **Biblioteca Python (`BancoDados.py`):** limpa o `bd.sqlite` para isolar os testes, valida persistência real e gera dados únicos.
- **Page Objects (`.resource`) e Variáveis (`${}`, `@{}` e `&{}`):** organização em camadas na pasta `robot/`.
- **BDD, `Test Template` e Tags:** fluxo E2E legível, testes *Data-Driven* de valor limite e execução filtrada.

## Instalação
```bash
npm install
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
rfbrowser init chromium
```

## Como Executar
Deixe a porta `3000` livre (o servidor sobe automaticamente) e rode:

```bash
# Suíte completa
robot -d results robot/tests/

# Demonstração visual (navegador aberto + câmera lenta)
robot -v HEADLESS:False -v SLOW_MO:500ms -i e2e -d results robot/tests/

# Filtrando por tag (smoke, negativo, limite, http, seguranca)
robot -i smoke -d results robot/tests/
```

Os relatórios ficam em `results/report.html` e `results/log.html`.