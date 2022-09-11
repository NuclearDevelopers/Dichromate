using System.Diagnostics;
using System.Net;
using static System.Net.Mime.MediaTypeNames;

namespace Updater
{
    public class Functions
    {
        public static readonly string 
            installPath = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData) + "\\Dichromate\\Application";
        public static readonly string
            updatePath = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData) + "\\Dichromate\\Updater";
        public static bool IsBrowserInstalled()
        {
            if (File.Exists(installPath + "\\chrome.exe"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static string BrowserVersion()
        {
            FileVersionInfo fileversion = FileVersionInfo.GetVersionInfo(installPath + "\\chrome.exe");
            var version = fileversion.ProductVersion.ToString().Replace(Environment.NewLine, "");
            return version;
        }

        public static string FindLatestVersion()
        {
            using (WebClient webClient = new WebClient())
            {
                webClient.DownloadFile("https://raw.githubusercontent.com/NuclearDevelopers/Dichromate/main/version.txt", updatePath + "\\version.txt");
                string ver = File.ReadAllText(updatePath + "\\version.txt");
                string latestversion = ver.ToString().Replace(Environment.NewLine, "");
                return latestversion;
            }
        }

        public static void InstallBrowser()
        {
            using (WebClient webClient = new WebClient())
            {
                var version = FindLatestVersion();
                webClient.DownloadFile("https://github.com/NuclearDevelopers/Dichromate/releases/download/" + version + "/dichromate-" + version + ".exe", updatePath + "\\DichromateInstaller.exe");
                
                var installer = Process.Start(Path.Combine(updatePath + "\\DichromateInstaller.exe"));
                installer.WaitForExit();
            }
        }

        public static bool TaskExists(string taskname)
        {
            ProcessStartInfo start = new ProcessStartInfo();
            start.FileName = "schtasks.exe";
            start.UseShellExecute = false;
            start.CreateNoWindow = true;
            start.WindowStyle = ProcessWindowStyle.Hidden;
            start.Arguments = "/query /TN " + taskname;
            start.RedirectStandardOutput = true;
            using (Process process = Process.Start(start))
            {
                using (StreamReader reader = process.StandardOutput)
                {
                    string stdout = reader.ReadToEnd();
                    if (stdout.Contains(taskname))
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }

        public static void CreateTask()
        {
            string UserName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
            string FixedName = UserName.Replace(Environment.NewLine, "");

            string TaskXML = updatePath + "\\" + "DichromateUpdate.xml";
            string text = File.ReadAllText(TaskXML);
            
            string edit1 = text.Replace("DichromateUser", FixedName);
            string edit2 = edit1.Replace("CommandPath", installPath + "\\" + "DichromateSetup.exe");

            File.WriteAllText(TaskXML, edit2);

            ProcessStartInfo start = new ProcessStartInfo();
            start.FileName = "schtasks.exe";
            start.UseShellExecute = false;
            start.CreateNoWindow = true;
            start.WindowStyle = ProcessWindowStyle.Hidden;
            start.Arguments = $"/create /TN DichromateUpdate /XML {TaskXML}";
            
            Process.Start(start);
        }

        public static void CopyToUpdatePath()
        {

            string thisFile = AppDomain.CurrentDomain.FriendlyName;

            string Path = AppContext.BaseDirectory + "\\" + thisFile + ".exe";

            string FilePath = updatePath + "\\" + thisFile + ".exe";

            if (!File.Exists(FilePath))
            {
                File.Copy(Path, FilePath);
            }
        }
        public static void Close()
        {
            Environment.Exit(0);
        }
    }
}
