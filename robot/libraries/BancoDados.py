import os
import sqlite3
from datetime import datetime
from robot.api.deco import keyword


class BancoDados:
    """Biblioteca customizada em Python para controle e validacao do bd.sqlite."""

    def __init__(self, db_path="bd.sqlite"):
        self.db_path = os.path.abspath(db_path)

    def _conectar(self):
        return sqlite3.connect(self.db_path, timeout=10)

    def _buscar_tabela(self, cursor, nome_parcial):
        cursor.execute(
            "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
        )
        tabelas = [row[0] for row in cursor.fetchall()]
        alvo = nome_parcial.lower()
        for tabela in tabelas:
            if tabela.lower() == alvo or tabela.lower().startswith(alvo):
                return tabela
        raise ValueError(f"Tabela '{nome_parcial}' nao encontrada. Tabelas existentes: {tabelas}")

    @keyword("Limpar Banco De Dados")
    def limpar_banco_de_dados(self):
        """Remove todos os registros das tabelas mantendo a estrutura criada pelo Sequelize."""
        if not os.path.exists(self.db_path):
            return
        with self._conectar() as conn:
            cursor = conn.cursor()
            cursor.execute("PRAGMA foreign_keys = OFF;")
            cursor.execute(
                "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
            )
            tabelas = [row[0] for row in cursor.fetchall()]
            for tabela in tabelas:
                cursor.execute(f'DELETE FROM "{tabela}";')
            cursor.execute("PRAGMA foreign_keys = ON;")
            conn.commit()

    @keyword("Contar Registros Na Tabela")
    def contar_registros_na_tabela(self, nome_tabela):
        """Retorna a quantidade atual de registros em uma tabela do SQLite."""
        with self._conectar() as conn:
            cursor = conn.cursor()
            tabela_real = self._buscar_tabela(cursor, nome_tabela)
            cursor.execute(f'SELECT COUNT(*) FROM "{tabela_real}";')
            return int(cursor.fetchone()[0])

    @keyword("Gerar Nome Unico")
    def gerar_nome_unico(self, prefixo="Registro"):
        """Gera um texto unico com timestamp para evitar colisao de dados."""
        sufixo = datetime.now().strftime("%H%M%S%f")[:9]
        return f"{prefixo} {sufixo}"