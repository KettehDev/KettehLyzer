using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace KettehTools
{
    public class KettehToolsApp : Form
    {
        // ===== COLORS =====
        private readonly Color DarkBg = Color.FromArgb(10, 10, 20);
        private readonly Color DarkCard = Color.FromArgb(20, 20, 40);
        private readonly Color NeonPink = Color.FromArgb(255, 45, 155);
        private readonly Color NeonCyan = Color.FromArgb(0, 212, 255);
        private readonly Color NeonPurple = Color.FromArgb(180, 77, 255);
        private readonly Color TextColor = Color.FromArgb(240, 240, 255);
        private readonly Color TextMuted = Color.FromArgb(136, 136, 187);

        // ===== CONTROLS =====
        private TabControl mainTabs;
        private RichTextBox outputBox;
        private TextBox modPathBox;
        private Button scanButton, browseButton, hashButton, processButton;
        private Label statusLabel, modCountLabel;
        private ProgressBar progressBar;
        private ListView resultListView;

        public KettehToolsApp()
        {
            this.Text = "⚡ KETTEH TOOLS ⚡";
            this.Size = new Size(1100, 750);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = DarkBg;
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;

            // Set icon
            this.Icon = SystemIcons.Shield;

            InitializeUI();
            ApplyTheme();
        }

        private void InitializeUI()
        {
            // ─── TOP HEADER ──────────────────────────────────────────
            Label header = new Label
            {
                Text = "⚡ KETTEH TOOLS ⚡",
                Font = new Font("Consolas", 18, FontStyle.Bold),
                ForeColor = NeonPink,
                BackColor = DarkBg,
                Dock = DockStyle.Top,
                Height = 50,
                TextAlign = ContentAlignment.MiddleCenter
            };
            this.Controls.Add(header);

            // ─── MAIN TAB CONTROL ──────────────────────────────────
            mainTabs = new TabControl
            {
                Dock = DockStyle.Fill,
                BackColor = DarkBg,
                ForeColor = TextColor,
                Font = new Font("Segoe UI", 10, FontStyle.Regular),
                Padding = new Point(10, 5),
                Top = 50,
                Height = this.ClientSize.Height - 50
            };
            this.Controls.Add(mainTabs);

            // ─── TAB 1: MOD SCANNER ───────────────────────────────
            TabPage modScannerTab = new TabPage("🔍 Mod Scanner");
            modScannerTab.BackColor = DarkBg;
            mainTabs.TabPages.Add(modScannerTab);

            // Path input
            Label pathLabel = new Label
            {
                Text = "📂 Mods Folder:",
                ForeColor = TextColor,
                Location = new Point(20, 20),
                Size = new Size(100, 25),
                Font = new Font("Segoe UI", 10, FontStyle.Bold)
            };
            modScannerTab.Controls.Add(pathLabel);

            modPathBox = new TextBox
            {
                Location = new Point(130, 20),
                Size = new Size(600, 25),
                BackColor = DarkCard,
                ForeColor = TextColor,
                BorderStyle = BorderStyle.FixedSingle,
                Font = new Font("Segoe UI", 10),
                Text = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), ".minecraft", "mods")
            };
            modScannerTab.Controls.Add(modPathBox);

            browseButton = new Button
            {
                Text = "📁 Browse",
                Location = new Point(740, 18),
                Size = new Size(100, 30),
                BackColor = DarkCard,
                ForeColor = NeonCyan,
                FlatStyle = FlatStyle.Flat,
                Font = new Font("Segoe UI", 10, FontStyle.Bold)
            };
            browseButton.FlatAppearance.BorderColor = NeonCyan;
            browseButton.FlatAppearance.BorderSize = 1;
            browseButton.Click += BrowseButton_Click;
            modScannerTab.Controls.Add(browseButton);

            scanButton = new Button
            {
                Text = "🚀 SCAN",
                Location = new Point(850, 18),
                Size = new Size(120, 30),
                BackColor = NeonPink,
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                Font = new Font("Segoe UI", 10, FontStyle.Bold)
            };
            scanButton.FlatAppearance.BorderSize = 0;
            scanButton.Click += ScanButton_Click;
            modScannerTab.Controls.Add(scanButton);

            // Status
            statusLabel = new Label
            {
                Text = "Ready",
                ForeColor = TextMuted,
                Location = new Point(20, 60),
                Size = new Size(300, 20),
                Font = new Font("Segoe UI", 9)
            };
            modScannerTab.Controls.Add(statusLabel);

            modCountLabel = new Label
            {
                Text = "Mods: 0",
                ForeColor = TextMuted,
                Location = new Point(350, 60),
                Size = new Size(200, 20),
                Font = new Font("Segoe UI", 9)
            };
            modScannerTab.Controls.Add(modCountLabel);

            // Progress Bar
            progressBar = new ProgressBar
            {
                Location = new Point(20, 85),
                Size = new Size(950, 20),
                Style = ProgressBarStyle.Continuous,
                ForeColor = NeonPink,
                BackColor = DarkCard
            };
            modScannerTab.Controls.Add(progressBar);

            // Results List
            resultListView = new ListView
            {
                Location = new Point(20, 115),
                Size = new Size(950, 300),
                BackColor = DarkCard,
                ForeColor = TextColor,
                Font = new Font("Consolas", 9),
                BorderStyle = BorderStyle.FixedSingle,
                FullRowSelect = true,
                GridLines = true,
                View = View.Details
            };
            resultListView.Columns.Add("Mod Name", 300);
            resultListView.Columns.Add("Status", 150);
            resultListView.Columns.Add("Reason", 450);
            resultListView.Columns.Add("Type", 150);
            modScannerTab.Controls.Add(resultListView);

            // Output Box
            outputBox = new RichTextBox
            {
                Location = new Point(20, 425),
                Size = new Size(950, 180),
                BackColor = DarkCard,
                ForeColor = TextColor,
                Font = new Font("Consolas", 9),
                BorderStyle = BorderStyle.FixedSingle,
                ReadOnly = true,
                WordWrap = true
            };
            modScannerTab.Controls.Add(outputBox);

            // ─── TAB 2: TOOLS ───────────────────────────────────────
            TabPage toolsTab = new TabPage("🛠 Tools");
            toolsTab.BackColor = DarkBg;
            mainTabs.TabPages.Add(toolsTab);

            // ─── TAB 3: ABOUT ──────────────────────────────────────
            TabPage aboutTab = new TabPage("ℹ About");
            aboutTab.BackColor = DarkBg;
            mainTabs.TabPages.Add(aboutTab);

            Label aboutLabel = new Label
            {
                Text = "⚡ KETTEH TOOLS v2.0 ⚡\n\n" +
                       "🔍 Mod Scanner - Detect cheats in your mods folder\n" +
                       "🔒 File Hasher - Get SHA1/MD5 of any file\n" +
                       "🖥️ Process Scanner - Scan running processes\n\n" +
                       "🔥 Made by Ketteh - Justice Served",
                ForeColor = TextColor,
                Location = new Point(50, 50),
                Size = new Size(800, 300),
                Font = new Font("Segoe UI", 12),
                TextAlign = ContentAlignment.MiddleCenter
            };
            aboutTab.Controls.Add(aboutLabel);

            // ─── TOOLS TAB CONTROLS ─────────────────────────────────
            int toolsY = 20;

            // File Hasher
            Label hashLabel = new Label
            {
                Text = "🔒 File Hasher:",
                ForeColor = TextColor,
                Location = new Point(20, toolsY),
                Size = new Size(100, 25),
                Font = new Font("Segoe UI", 10, FontStyle.Bold)
            };
            toolsTab.Controls.Add(hashLabel);

            TextBox hashPathBox = new TextBox
            {
                Location = new Point(130, toolsY),
                Size = new Size(600, 25),
                BackColor = DarkCard,
                ForeColor = TextColor,
                BorderStyle = BorderStyle.FixedSingle,
                Font = new Font("Segoe UI", 10),
                Name = "hashPathBox"
            };
            toolsTab.Controls.Add(hashPathBox);

            Button hashBrowseBtn = new Button
            {
                Text = "📁 Browse",
                Location = new Point(740, toolsY - 2),
                Size = new Size(100, 30),
                BackColor = DarkCard,
                ForeColor = NeonCyan,
                FlatStyle = FlatStyle.Flat,
                Font = new Font("Segoe UI", 10, FontStyle.Bold)
            };
            hashBrowseBtn.FlatAppearance.BorderColor = NeonCyan;
            hashBrowseBtn.FlatAppearance.BorderSize = 1;
            hashBrowseBtn.Click += (s, e) => {
                using (OpenFileDialog ofd = new OpenFileDialog())
                {
                    if (ofd.ShowDialog() == DialogResult.OK)
                    {
                        hashPathBox.Text = ofd.FileName;
                        HashFile(ofd.FileName);
                    }
                }
            };
            toolsTab.Controls.Add(hashBrowseBtn);

            hashButton = new Button
            {
                Text = "🔐 Hash It!",
                Location = new Point(850, toolsY - 2),
                Size = new Size(100, 30),
                BackColor = NeonPurple,
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                Font = new Font("Segoe UI", 10, FontStyle.Bold)
            };
            hashButton.FlatAppearance.BorderSize = 0;
            hashButton.Click += (s, e) => {
                if (!string.IsNullOrEmpty(hashPathBox.Text) && File.Exists(hashPathBox.Text))
                {
                    HashFile(hashPathBox.Text);
                }
                else
                {
                    MessageBox.Show("Please select a valid file!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            };
            toolsTab.Controls.Add(hashButton);

            toolsY += 50;

            // Process Scanner
            Label procLabel = new Label
            {
                Text = "🖥️ Process Scanner:",
                ForeColor = TextColor,
                Location = new Point(20, toolsY),
                Size = new Size(120, 25),
                Font = new Font("Segoe UI", 10, FontStyle.Bold)
            };
            toolsTab.Controls.Add(procLabel);

            processButton = new Button
            {
                Text = "🔍 Scan Processes",
                Location = new Point(150, toolsY - 2),
                Size = new Size(150, 30),
                BackColor = NeonCyan,
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                Font = new Font("Segoe UI", 10, FontStyle.Bold)
            };
            processButton.FlatAppearance.BorderSize = 0;
            processButton.Click += ProcessButton_Click;
            toolsTab.Controls.Add(processButton);

            RichTextBox procOutput = new RichTextBox
            {
                Location = new Point(20, toolsY + 40),
                Size = new Size(960, 350),
                BackColor = DarkCard,
                ForeColor = TextColor,
                Font = new Font("Consolas", 9),
                BorderStyle = BorderStyle.FixedSingle,
                ReadOnly = true,
                Name = "procOutput"
            };
            toolsTab.Controls.Add(procOutput);
        }

        private void ApplyTheme()
        {
            foreach (Control ctrl in this.Controls)
            {
                ApplyThemeToControl(ctrl);
            }
        }

        private void ApplyThemeToControl(Control ctrl)
        {
            if (ctrl is Button btn)
            {
                btn.FlatStyle = FlatStyle.Flat;
                btn.FlatAppearance.BorderSize = 1;
                btn.FlatAppearance.BorderColor = NeonPink;
                btn.BackColor = DarkCard;
                btn.ForeColor = TextColor;
                btn.Font = new Font("Segoe UI", 9, FontStyle.Bold);
            }
            else if (ctrl is TextBox txt)
            {
                txt.BackColor = DarkCard;
                txt.ForeColor = TextColor;
                txt.BorderStyle = BorderStyle.FixedSingle;
            }
            else if (ctrl is RichTextBox rtb)
            {
                rtb.BackColor = DarkCard;
                rtb.ForeColor = TextColor;
                rtb.BorderStyle = BorderStyle.FixedSingle;
            }
            else if (ctrl is ListView lv)
            {
                lv.BackColor = DarkCard;
                lv.ForeColor = TextColor;
                lv.GridLines = true;
            }

            foreach (Control child in ctrl.Controls)
            {
                ApplyThemeToControl(child);
            }
        }

        // ─── BROWSE BUTTON ──────────────────────────────────────────
        private void BrowseButton_Click(object sender, EventArgs e)
        {
            using (FolderBrowserDialog fbd = new FolderBrowserDialog())
            {
                fbd.Description = "Select your Minecraft mods folder";
                fbd.SelectedPath = modPathBox.Text;
                if (fbd.ShowDialog() == DialogResult.OK)
                {
                    modPathBox.Text = fbd.SelectedPath;
                }
            }
        }

        // ─── SCAN BUTTON ────────────────────────────────────────────
        private async void ScanButton_Click(object sender, EventArgs e)
        {
            string modsPath = modPathBox.Text;

            if (!Directory.Exists(modsPath))
            {
                MessageBox.Show("Invalid mods folder path!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            scanButton.Enabled = false;
            progressBar.Value = 0;
            resultListView.Items.Clear();
            outputBox.Clear();
            statusLabel.Text = "🔍 Scanning...";

            var jarFiles = Directory.GetFiles(modsPath, "*.jar");
            modCountLabel.Text = $"Mods: {jarFiles.Length}";

            var cheats = new List<string>();
            var verified = new List<string>();
            var unknown = new List<string>();

            int total = jarFiles.Length;
            int processed = 0;

            await Task.Run(() =>
            {
                foreach (string file in jarFiles)
                {
                    string fileName = Path.GetFileName(file);
                    processed++;

                    this.Invoke((MethodInvoker)delegate
                    {
                        int percent = (processed * 100) / total;
                        progressBar.Value = Math.Min(percent, 100);
                        statusLabel.Text = $"🔍 Scanning {fileName} ({processed}/{total})";
                    });

                    // Check if it's a cheat by name
                    string lowerName = fileName.ToLower();
                    bool isCheat = false;
                    string reason = "";

                    string[] cheatNames = {
                        "wurst", "meteor", "impact", "liquidbounce", "aristois", "future",
                        "sigma", "vape", "entropy", "dqrkis", "ketteh", "eventplugin",
                        "crystalaura", "autocrystal", "anchoraura", "bedaura",
                        "client", "hack", "cheat", "module"
                    };

                    foreach (string cheat in cheatNames)
                    {
                        if (lowerName.Contains(cheat))
                        {
                            isCheat = true;
                            reason = $"BLATANT CHEAT: {cheat}";
                            break;
                        }
                    }

                    if (isCheat)
                    {
                        cheats.Add($"🚨 {fileName} — {reason}");
                        this.Invoke((MethodInvoker)delegate
                        {
                            var item = new ListViewItem(fileName);
                            item.SubItems.Add("🚨 CHEAT");
                            item.SubItems.Add(reason);
                            item.SubItems.Add("CLIENT");
                            item.BackColor = Color.FromArgb(40, 0, 0);
                            item.ForeColor = Color.Red;
                            resultListView.Items.Add(item);
                        });
                        continue;
                    }

                    // Check hash against Modrinth
                    try
                    {
                        string sha1 = GetFileHash(file, "SHA1");
                        bool isVerified = CheckModrinth(sha1).Result;

                        if (isVerified)
                        {
                            verified.Add($"✅ {fileName} — Verified");
                            this.Invoke((MethodInvoker)delegate
                            {
                                var item = new ListViewItem(fileName);
                                item.SubItems.Add("✅ VERIFIED");
                                item.SubItems.Add("Verified by Modrinth");
                                item.SubItems.Add("SAFE");
                                item.BackColor = Color.FromArgb(0, 40, 0);
                                item.ForeColor = Color.Green;
                                resultListView.Items.Add(item);
                            });
                        }
                        else
                        {
                            unknown.Add($"❓ {fileName} — Unknown");
                            this.Invoke((MethodInvoker)delegate
                            {
                                var item = new ListViewItem(fileName);
                                item.SubItems.Add("❓ UNKNOWN");
                                item.SubItems.Add("Not verified by Modrinth");
                                item.SubItems.Add("UNKNOWN");
                                item.BackColor = Color.FromArgb(40, 40, 0);
                                item.ForeColor = Color.Yellow;
                                resultListView.Items.Add(item);
                            });
                        }
                    }
                    catch
                    {
                        unknown.Add($"❓ {fileName} — Error scanning");
                    }
                }
            });

            statusLabel.Text = "✅ Scan Complete!";
            progressBar.Value = 100;
            scanButton.Enabled = true;

            // Output summary
            outputBox.AppendText("═══════════════════════════════════════════════════════════════════\n");
            outputBox.AppendText($"📊 SCAN RESULTS\n");
            outputBox.AppendText($"═══════════════════════════════════════════════════════════════════\n\n");
            outputBox.AppendText($"🚨 Cheats Found: {cheats.Count}\n", Color.Red);
            outputBox.AppendText($"✅ Verified: {verified.Count}\n", Color.Green);
            outputBox.AppendText($"❓ Unknown: {unknown.Count}\n", Color.Yellow);
            outputBox.AppendText($"📦 Total: {total}\n", Color.White);
            outputBox.AppendText($"\n═══════════════════════════════════════════════════════════════════\n");

            if (cheats.Count > 0)
            {
                outputBox.AppendText($"\n🚨 CHEATS DETECTED:\n", Color.Red);
                foreach (string cheat in cheats)
                {
                    outputBox.AppendText($"  {cheat}\n", Color.Red);
                }
            }

            if (verified.Count > 0)
            {
                outputBox.AppendText($"\n✅ VERIFIED MODS:\n", Color.Green);
                foreach (string v in verified.Take(10))
                {
                    outputBox.AppendText($"  {v}\n", Color.Green);
                }
                if (verified.Count > 10) outputBox.AppendText($"  ... and {verified.Count - 10} more\n", Color.Gray);
            }

            if (unknown.Count > 0)
            {
                outputBox.AppendText($"\n❓ UNKNOWN MODS:\n", Color.Yellow);
                foreach (string u in unknown.Take(10))
                {
                    outputBox.AppendText($"  {u}\n", Color.Yellow);
                }
                if (unknown.Count > 10) outputBox.AppendText($"  ... and {unknown.Count - 10} more\n", Color.Gray);
            }
        }

        // ─── HELPERS ────────────────────────────────────────────────
        private string GetFileHash(string filePath, string algorithm)
        {
            using (var stream = File.OpenRead(filePath))
            {
                HashAlgorithm algo = algorithm == "SHA1" ? SHA1.Create() : MD5.Create();
                byte[] hash = algo.ComputeHash(stream);
                return BitConverter.ToString(hash).Replace("-", "").ToLower();
            }
        }

        private async Task<bool> CheckModrinth(string sha1)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.Timeout = TimeSpan.FromSeconds(5);
                    var response = await client.GetAsync($"https://api.modrinth.com/v2/version_file/{sha1}");
                    return response.IsSuccessStatusCode;
                }
            }
            catch
            {
                return false;
            }
        }

        private void HashFile(string filePath)
        {
            try
            {
                string sha1 = GetFileHash(filePath, "SHA1");
                string md5 = GetFileHash(filePath, "MD5");
                string output = $"═══════════════════════════════════════════════════════════════════\n";
                output += $"🔐 FILE HASH RESULTS\n";
                output += $"═══════════════════════════════════════════════════════════════════\n\n";
                output += $"📁 File: {Path.GetFileName(filePath)}\n";
                output += $"📂 Path: {filePath}\n";
                output += $"📦 Size: {new FileInfo(filePath).Length:N0} bytes\n\n";
                output += $"🔑 SHA1: {sha1}\n";
                output += $"🔑 MD5:  {md5}\n";
                output += $"\n═══════════════════════════════════════════════════════════════════\n";

                // Find output box in tools tab
                var procOutput = mainTabs.TabPages[1].Controls.Find("procOutput", true).FirstOrDefault() as RichTextBox;
                if (procOutput != null)
                {
                    procOutput.Text = output;
                    procOutput.AppendText("\n✅ Hash calculation complete!", Color.Green);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error hashing file: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void ProcessButton_Click(object sender, EventArgs e)
        {
            var procOutput = mainTabs.TabPages[1].Controls.Find("procOutput", true).FirstOrDefault() as RichTextBox;
            if (procOutput == null) return;

            procOutput.Clear();
            procOutput.AppendText("═══════════════════════════════════════════════════════════════════\n");
            procOutput.AppendText("🖥️ RUNNING PROCESSES\n");
            procOutput.AppendText("═══════════════════════════════════════════════════════════════════\n\n");

            var processes = System.Diagnostics.Process.GetProcesses();

            // Check for Minecraft
            var mcProcesses = processes.Where(p => p.ProcessName.ToLower().Contains("java") || p.ProcessName.ToLower().Contains("javaw"));
            var otherProcesses = processes.Where(p => !p.ProcessName.ToLower().Contains("java") && !p.ProcessName.ToLower().Contains("javaw"));

            procOutput.AppendText("🎮 MINECRAFT PROCESSES:\n", Color.Cyan);
            if (mcProcesses.Any())
            {
                foreach (var p in mcProcesses)
                {
                    try
                    {
                        procOutput.AppendText($"  ▶ {p.ProcessName}.exe (PID: {p.Id}) — Running\n", Color.Green);
                    }
                    catch { }
                }
            }
            else
            {
                procOutput.AppendText("  ❌ No Minecraft processes found\n", Color.Red);
            }

            procOutput.AppendText("\n📊 OTHER PROCESSES: (Top 20)\n", Color.Cyan);
            int count = 0;
            foreach (var p in otherProcesses.OrderBy(p => p.ProcessName))
            {
                if (count++ > 20) break;
                try
                {
                    string mem = (p.WorkingSet64 / 1024 / 1024).ToString() + " MB";
                    procOutput.AppendText($"  ▸ {p.ProcessName}.exe (PID: {p.Id}) — {mem}\n", Color.Gray);
                }
                catch { }
            }

            procOutput.AppendText("\n═══════════════════════════════════════════════════════════════════\n");
            procOutput.AppendText($"✅ Total Processes: {processes.Length}\n", Color.Green);
            procOutput.AppendText($"✅ Minecraft Processes: {mcProcesses.Count()}\n", Color.Green);
            procOutput.AppendText("═══════════════════════════════════════════════════════════════════\n");
        }
    }

    // ─── EXTENSION METHODS ──────────────────────────────────────
    public static class RichTextBoxExtensions
    {
        public static void AppendText(this RichTextBox box, string text, Color color)
        {
            box.SelectionStart = box.TextLength;
            box.SelectionLength = 0;
            box.SelectionColor = color;
            box.AppendText(text);
            box.SelectionColor = box.ForeColor;
        }
    }

    // ─── PROGRAM ENTRY ──────────────────────────────────────────
    public static class Program
    {
        [STAThread]
        public static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new KettehToolsApp());
        }
    }
}
