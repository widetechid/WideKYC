package com.wide.widekyc.merchantserver;

public class RequestParams {
    public RequestParams(){}

    private String product;
    private String serviceLevel;
    private String metaInfo;
    private String trxId;

    public RequestParams(String product, String serviceLevel, String metaInfo, String trxId) {
        this.product = product;
        this.serviceLevel = serviceLevel;
        this.metaInfo = metaInfo;
        this.trxId = trxId;
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

    @Override
    public String toString() {
        return "RequestParams{" +
                "product='" + product + '\'' +
                ", serviceLevel='" + serviceLevel + '\'' +
                ", metaInfo='" + metaInfo + '\'' +
                ", trxId='" + trxId + '\'' +
                '}';
    }
}
