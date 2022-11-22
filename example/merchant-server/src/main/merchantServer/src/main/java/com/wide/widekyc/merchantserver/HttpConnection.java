package com.wide.widekyc.merchantserver;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

public class HttpConnection {
    protected HttpURLConnection httpURLConnection;

    public HttpURLConnection getHttpURLConnection(String apiName) {
        try{
            URL url = new URL("<widekyc_server_url>" + apiName);
            this.httpURLConnection = (HttpURLConnection) url.openConnection();

            this.httpURLConnection.setRequestMethod("POST");
            this.httpURLConnection.setRequestProperty("token", "<client_token>");
            this.httpURLConnection.setRequestProperty("Content-Type", "application/json");
            this.httpURLConnection.setRequestProperty("Accept", "*/*");
            this.httpURLConnection.setDoOutput(true);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }

        return httpURLConnection;
    }
}
