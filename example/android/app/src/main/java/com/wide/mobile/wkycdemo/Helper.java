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
        return prefs.getString("host", "host_url");//"No name defined" is the default value.
    }

    public static String getApiInput(Context context){
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getString("api", "api_name");//"No name defined" is the default value.
    }
}
