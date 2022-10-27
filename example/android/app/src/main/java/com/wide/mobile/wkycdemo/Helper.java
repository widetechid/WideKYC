package com.wide.mobile.wkycdemo;

import android.content.Context;
import android.content.SharedPreferences;

public class Helper {
    private static final String PREFS_NAME = "EXAMPLE_PREF";

    public static void setHostInput(Context context, String input){
        SharedPreferences.Editor editor = context.getSharedPreferences(PREFS_NAME,  Context.MODE_PRIVATE).edit();
        editor.putString("host", input);
        editor.commit();
    }

    public static void  setApiInput(Context context, String input){
        SharedPreferences.Editor editor = context.getSharedPreferences(PREFS_NAME,  Context.MODE_PRIVATE).edit();
        editor.putString("api", input);
        editor.commit();
    }

    public static String getHostInput(Context context){
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        String host = prefs.getString("host", "http://[host_ip]:[host_port]/");
        if(host.trim().length()==0){
            return "http://[host_ip]:[host_port]/";
        }
        else{
            return host;
        }
    }

    public static String getApiInput(Context context){
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        String api = prefs.getString("api", "[api_name]");
        if(api.trim().length()==0){
            return "[api_name]";
        }
        else{
            return api;
        }
    }
}
