import pytest
from bonsai import LDAPConnection, LDAPSearchScope


@pytest.mark.parametrize(
    ("base", "scope", "filter_exp", "expected_num"),
    [
        ("ou=People,o=nhs", LDAPSearchScope.ONELEVEL, "(uid=1*)", 2),
        ("uid=1111,ou=People,o=nhs", LDAPSearchScope.BASE, None, 1),
        ("uid=2222,ou=People,o=nhs", LDAPSearchScope.BASE, "(objectClass=nhsPerson)", 1),
        ("uid=6789,ou=People,o=nhs", LDAPSearchScope.BASE, "(objectClass=nhsPerson)", 1),
        ("uid=XXXXXXXX,ou=People,o=nhs", LDAPSearchScope.BASE, "(objectClass=nhsPerson&nhsPersonStatus=1)", 0),
        ("uniqueidentifier=T1431,ou=Organisations,o=nhs", LDAPSearchScope.BASE, "(objectClass=nhsOrg)", 1),
        ("ou=Organisations,o=nhs", LDAPSearchScope.SUBTREE, "(&(objectClass=*)(postalCode=E14 5EA))", 1),
        ("ou=Organisations,o=nhs", LDAPSearchScope.SUBTREE, "(&(objectClass=*)(o=*SECURITY*))", 1),
    ],
)
async def test_basic_ldap_searches(
    base: str, scope: int | None, filter_exp: str | None, expected_num: int, connection: LDAPConnection
):
    res = connection.search(
        base=base,
        scope=scope,
        filter_exp=filter_exp,
    )

    assert len(res) == expected_num
