package com.wide.ekycaggr.merchantserver;

import java.util.UUID;

public class RequestParams {
    public RequestParams(){}

    private String product;
    private String serviceLevel;
    private String metaInfo;
    private String trxId;
    private String custRefNo = UUID.randomUUID().toString();

    public RequestParams(String product, String serviceLevel, String metaInfo, String trxId, String custRefNo) {
        this.product = product;
        this.serviceLevel = serviceLevel;
        this.metaInfo = metaInfo;
        this.trxId = trxId;
        this.custRefNo = custRefNo;
    }

    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public String getServiceLevel() {
        return serviceLevel;
    }

    public void setServiceLevel(String serviceLevel) {
        this.serviceLevel = serviceLevel;
    }

    public String getMetaInfo() {
        return metaInfo;
    }

    public void setMetaInfo(String metaInfo) {
        this.metaInfo = metaInfo;
    }

    public String getTrxId() {
        return trxId;
    }

    public void setTrxId(String trxId) {
        this.trxId = trxId;
    }

    public String getCustRefNo() {
        return custRefNo;
    }

    public void setCustRefNo(String custRefNo) {
        this.custRefNo = custRefNo;
    }

    @Override
    public String toString() {
        return "RequestParams{" +
                "product='" + product + '\'' +
                ", serviceLevel='" + serviceLevel + '\'' +
                ", metaInfo='" + metaInfo + '\'' +
                ", trxId='" + trxId + '\'' +
                ", custRefNo='" + custRefNo + '\'' +
                '}';
    }
}
