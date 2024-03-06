package com.wide.mobile.wkycdemo;

import android.util.Log;

import org.json.JSONObject;

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
                String readLine;
                BufferedReader responseReader = new BufferedReader(new InputStreamReader(httpConn.getInputStream(), "UTF-8"));
                StringBuilder response = new StringBuilder();
                while ((readLine = responseReader.readLine()) != null) {
                    response.append(readLine);
                }
                responseReader.close();
                Log.d(TAG, requestUrl +", responds : " + response);
                JSONObject responseObj = new JSONObject(response.toString());
                responseObj.put("statusCode","SUCCESSFUL");
                return responseObj.toString();
            }
            else if(HttpURLConnection.HTTP_INTERNAL_ERROR == resultCode){
                BufferedReader errorReader = new BufferedReader(new InputStreamReader(httpConn.getErrorStream()));
                String errorMessage;
                StringBuilder response = new StringBuilder();
                while ((errorMessage = errorReader.readLine()) != null) {
                    response.append(errorMessage);
                }
                errorReader.close();
                Log.d(TAG, requestUrl +", responds : " + response);
                JSONObject responseObj = new JSONObject(response.toString());
                responseObj.put("statusCode", "ERROR");
                return responseObj.toString();
            }
            else{
                return "";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error : " + e.getMessage();
        }
    }
}
