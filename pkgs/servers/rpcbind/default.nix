{ fetchurl, fetchpatch, stdenv, pkgconfig, libtirpc
, useSystemd ? true, systemd }:

let version = "0.2.3";
in stdenv.mkDerivation rec {
  name = "rpcbind-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/rpcbind/${version}/${name}.tar.bz2";
    sha256 = "0yyjzv4161rqxrgjcijkrawnk55rb96ha0pav48s03l2klx855wq";
  };

  patches = [
    ./sunrpc.patch
    ./0001-handle_reply-Don-t-use-the-xp_auth-pointer-directly.patch
    (fetchpatch {
      url = "https://sources.debian.net/data/main/r/rpcbind/0.2.3-0.5/debian/patches/CVE-2015-7236.patch";
      sha256 = "1wsv5j8f5djzxr11n4027x107cam1avmx9w34g6l5d9s61j763wq";
    })
  ];

  buildInputs = [ libtirpc ]
             ++ stdenv.lib.optional useSystemd systemd;

  configureFlags = stdenv.lib.optional (!useSystemd) "--with-systemdsystemunitdir=no";

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "ONC RPC portmapper";
    license = licenses.bsd3;
    platforms = platforms.unix;
    homepage = "http://sourceforge.net/projects/rpcbind/";
    maintainers = with maintainers; [ abbradar ];
    longDescription = ''
      Universal addresses to RPC program number mapper.
    '';
  };
}
