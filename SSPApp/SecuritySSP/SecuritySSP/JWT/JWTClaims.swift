//
//  JWTClaims.swift
//  SecuritySSP
//

import Foundation

///based on java code from eu.h2020.symbiote.security.commons.jwt
public class JWTClaims {
    var jti: String = ""
    var alg: String = ""
    var iss: String = ""
    var sub: String = ""
    var iat: UInt64 = 0 //long
    var exp: UInt64 = 0
    var ipk: String = ""
    var spk: String = ""
    var att = [String : String]()
    var ttyp: String = ""
    
//
//    public JWTClaims(Object jti, Object alg, Object iss, Object sub, Object iat, Object exp, Object ipk, Object spk,
//    Object ttyp, Map<String, String> att) {
//    this.jti = (String) jti;
//    this.alg = (String) alg;
//    this.iss = (String) iss;
//    this.sub = (String) sub;
//    String stringToConvert = String.valueOf(iat);
//    this.iat = Long.parseLong(stringToConvert) * 1000;
//    stringToConvert = String.valueOf(exp);
//    this.exp = Long.parseLong(stringToConvert) * 1000;
//    this.ipk = (String) ipk;
//    this.spk = (String) spk;
//    this.att = att;
//    this.ttyp = (String) ttyp;
//    }
    
  
    public func toString() -> String {
    return "JWTClaims{" +
        "jti='" + jti + "'" +
        ", alg='" + alg + "'" +
            ", iss='" + iss + "'" +
            ", sub='" + sub + "'" +
            ", iat='" + iat + "'" +
            ", exp='" + exp + "'" +
            ", ipk='" + ipk + "'" +
            ", spk='" + spk + "'" +
            ", att='" + att + "'" +
            ", ttyp'" + ttyp + "'" +
        "}";
    }
}
