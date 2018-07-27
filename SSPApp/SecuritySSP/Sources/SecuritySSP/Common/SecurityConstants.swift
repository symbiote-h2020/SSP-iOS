//
//  SecurityConstants.swift
//  SecuritySSP


import Foundation

///based on java code from eu.h2020.symbiote.security
public class SecurityConstants{
    static let  serialVersionUID = 7526472295622776147;
    
    // Security GLOBAL
    static let CURVE_NAME = "secp256r1";
    static let KEY_PAIR_GEN_ALGORITHM = "ECDSA";
    static let SIGNATURE_ALGORITHM = "SHA256withECDSA";
    
    // AAM GLOBAL
    static let CORE_AAM_FRIENDLY_NAME = "SymbIoTe Core AAM";
    static let CORE_AAM_INSTANCE_ID = "SymbIoTe_Core_AAM";
    
    // component certificates resolver constants
    static let AAM_COMPONENT_NAME = "aam";
    
    // AAM REST paths
    static let AAM_GET_AVAILABLE_AAMS = "/get_available_aams";
    static let AAM_GET_AAMS_INTERNALLY = "/get_internally_aams";
    static let AAM_GET_COMPONENT_CERTIFICATE = "/get_component_certificate";
    static let AAM_GET_FOREIGN_TOKEN = "/get_foreign_token";
    static let AAM_GET_GUEST_TOKEN = "/get_guest_token";
    static let AAM_GET_HOME_TOKEN = "/get_home_token";
    static let AAM_GET_USER_DETAILS = "/get_user_details";
    static let AAM_MANAGE_PLATFORMS = "/manage_platforms";
    static let AAM_MANAGE_USERS = "/manage_users";
    static let AAM_REVOKE_CREDENTIALS = "/revoke_credentials";
    static let AAM_SIGN_CERTIFICATE_REQUEST = "/sign_certificate_request";
    static let AAM_VALIDATE_CREDENTIALS = "/validate_credentials";
    static let AAM_VALIDATE_FOREIGN_TOKEN_ORIGIN_CREDENTIALS = "/validate_foreign_token_origin_credentials";
    
    
    // tokens
    static let TOKEN_HEADER_NAME = "x-auth-token";
    static let  JWT_PARTS_COUNT = 3; //Header, body and signature
    static let CLAIM_NAME_TOKEN_TYPE = "ttyp";
    static let SYMBIOTE_ATTRIBUTES_PREFIX = "SYMBIOTE_";
    static let FEDERATION_CLAIM_KEY_PREFIX = "federation_";
    static let GUEST_NAME = "guest";
    
    // certificates
    static let CLIENT_CERTIFICATE_HEADER_NAME = "x-auth-client-cert";
    static let AAM_CERTIFICATE_HEADER_NAME = "x-auth-aam-cert";
    static let FOREIGN_TOKEN_ISSUING_AAM_CERTIFICATE = "x-auth-iss-cert";
    
    // Security Request Headers
    static let SECURITY_CREDENTIALS_TIMESTAMP_HEADER = "x-auth-timestamp";
    static let SECURITY_CREDENTIALS_SIZE_HEADER = "x-auth-size";
    static let SECURITY_CREDENTIALS_HEADER_PREFIX = "x-auth-";
    static let SECURITY_RESPONSE_HEADER = "x-auth-response";
    
    //Access Policy JSON fields
    //Single Token
    static let ACCESS_POLICY_JSON_FIELD_TYPE = "policyType";
    static let ACCESS_POLICY_JSON_FIELD_CLAIMS = "requiredClaims";
    
    //Composite AP
    static let ACCESS_POLICY_JSON_FIELD_OPERATOR = "relationOperator";
    static let ACCESS_POLICY_JSON_FIELD_SINGLE_TOKEN_AP = "singleTokenAccessPolicySpecifiers";
    static let ACCESS_POLICY_JSON_FIELD_COMPOSITE_AP = "compositeAccessPolicySpecifiers";
    
    static let ERROR_DESC_UNSUPPORTED_ACCESS_POLICY_TYPE = "Access policy type not suppoted!";
}
