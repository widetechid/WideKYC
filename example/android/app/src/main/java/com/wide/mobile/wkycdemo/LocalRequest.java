package com.wide.mobile.wkycdemo;

import android.util.Log;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class LocalRequest {
    final static String TAG = "LocalRequest";
    public String request(String requestUrl, String requestData, String token) throws Exception {
        try {
            URL url = new URL(requestUrl);
            HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
            httpConn.setDoOutput(true);
            httpConn.setDoInput(true);
            httpConn.setUseCaches(false);
            httpConn.setRequestMethod("POST");
            httpConn.setRequestProperty("Content-Type", "application/json");
            httpConn.setRequestProperty("Connection", "Keep-Alive");
            httpConn.setRequestProperty("Charset", "UTF-8");
            if(token != null){
                httpConn.setRequestProperty("token", token);
            }
            httpConn.connect();

            DataOutputStream dos = new DataOutputStream(httpConn.getOutputStream());
            dos.writeBytes(requestData);
            dos.flush();
            dos.close();

            int resultCode = httpConn.getResponseCode();

            Log.d(TAG, requestUrl +", request data : " + requestData);
            Log.d(TAG, requestUrl + ", result code : " + resultCode);
            if (HttpURLConnection.HTTP_OK == resultCode) {
                StringBuffer sb = new StringBuffer();
                String readLine = new String();
                BufferedReader responseReader = new BufferedReader(new InputStreamReader(httpConn.getInputStream(), "UTF-8"));
                while ((readLine = responseReader.readLine()) != null) {
                    sb.append(readLine).append("\n");
                }
                responseReader.close();
                Log.d(TAG, requestUrl +", responds : " + sb.toString());
                return sb.toString();
            }
            else{
                return resultCode+"";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error : " + e.getMessage();
        }
    }
}
