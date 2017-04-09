#!/bin/sh


function _random_string(len, alphabet, alphabet_len, _result, _i) {
    for (_i=0; _i<len; _i++) {
        _result = _result alphabet[ random_int(1, alphabet_len) ];
    }
    return _result;
}

function random_string(opt, len) {
    if (!is_define_T) {
        is_define_T = 1;
        T_LEN_LOWER = split("a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z", T_LOWER, ",");
        T_LEN_UPPER = split("A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z", T_UPPER, ",");
        T_LEN_DEFAULT = split("a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z", T_DEFAULT, ",");
    }
   
    if (opt == "lower") {
        return _random_string(len, T_LOWER, T_LEN_LOWER);
    } else if (opt == "upper") {
        return _random_string(len, T_UPPER, T_LEN_UPPER);
    } else {
        return _random_string(len, T_DEFAULT, T_LEN_DEFAULT);
    }
}
# random string generater

KEYGEN=/usr/bin/ssh-keygen
KEYFILE=/root/.ssh/id_rsa

if [ ! -f $KEYFILE ]; then
  $KEYGEN -q -t rsa -N "" -f $KEYFILE
  cat $KEYFILE.pub >> /root/.ssh/authorized_keys
fi

echo "== Use this private key to log in =="
cat $KEYFILE

SFTPKEY=random_string("upper",16)

echo $SFTPKEY

echo ssh:$SFTPKEY | chpasswd

sudo chown root /home/ssh
sudo chmod go-w /home/ssh
sudo mkdir /home/ssh/writable
sudo chown ssh:ssh /home/ssh/writable
sudo chmod ug+rwX /home/ssh/writable


chmod 600 /root/.ssh/authorized_keys

/usr/sbin/sshd -D -f /app/sshrun/sshd_config
