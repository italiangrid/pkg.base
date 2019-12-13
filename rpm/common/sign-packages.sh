#!/bin/bash
set -ex

required_env="PKG_SIGN_PACKAGES PKG_SIGN_KEY_PASSWORD PKG_SIGN_PUB_KEY PKG_SIGN_PRI_KEY BUILD_PLATFORM"

for v in ${required_env}; do
    if [ ! -n "${!v}" ]; then
        echo "${v} is required to sign packages"
        exit 1
    fi
done

if [ "${PKG_SIGN_PACKAGES}" = "y" ]; then

PKG_SIGN_PACKAGES_CMD=${PKG_SIGN_PACKAGES_CMD:-"rpmsign --addsign"}
gpg --import ${GPG_IMPORT_OPTS} ${PKG_SIGN_PUB_KEY}
gpg --allow-secret-key-import --import ${GPG_IMPORT_OPTS} ${PKG_SIGN_PRI_KEY}
gpg --list-keys

packages=$(find /packages/${BUILD_PLATFORM} -type f -name '*.rpm')

for p in ${packages}; do

cat <<EOF > sign-rpms.exp
#!/usr/bin/expect
set timeout -1;
spawn -nottyinit ${PKG_SIGN_PACKAGES_CMD} ${p};
expect -exact "Enter pass phrase:";
send -- "${PKG_SIGN_KEY_PASSWORD}\r";
expect eof;
EOF
  chmod +x sign-rpms.exp
  ./sign-rpms.exp
done

else
  echo "PKG_SIGN_PACKAGES is set but is not 'y'"
fi

echo "Done signing!"
