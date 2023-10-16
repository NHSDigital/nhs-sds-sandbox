from collections.abc import Generator

import pytest
from bonsai import LDAPClient, LDAPConnection


@pytest.fixture(name="connection")
def create_connection() -> Generator[LDAPConnection, None, None]:
    client = LDAPClient("ldap://localhost:11389")
    with client.connect() as conn:
        yield conn
