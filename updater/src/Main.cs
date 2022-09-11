﻿using System;
using System.Diagnostics;
using System.Net;
using System.Reflection;

namespace Updater
{
    public class MainClass
    { 
        public static void Main()
        {
            Functions.CopyToUpdatePath();

            string FilePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"Dichromate\Updater");
            
            if (Process.GetProcessesByName(Path.GetFileNameWithoutExtension(Assembly.GetEntryAssembly().Location)).Length > 1)
            {
                Process.GetCurrentProcess().Kill();
            }

            Directory.CreateDirectory(FilePath);

            if (!Functions.TaskExists(@"DichromateUpdate"))
            {
                using (WebClient webClient = new WebClient())
                {
                    webClient.DownloadFile("https://raw.githubusercontent.com/NuclearDevelopers/Dichromate/main/updater/DichromateUpdate.xml", Functions.updatePath + "\\DichromateUpdate.xml");
                }
                Functions.CreateTask();
            }

            if (Functions.IsBrowserInstalled())
            {
                if (Functions.FindLatestVersion() != Functions.BrowserVersion())
                {
                    Functions.InstallBrowser();
                    Functions.Close();
                }

                else
                {
                    Functions.Close();
                }
            }

            else
            {
                Functions.InstallBrowser();
                Functions.Close(); 
            }
        }
    }
}
