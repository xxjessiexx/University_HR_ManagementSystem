<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="HRHome.aspx.cs"
    Inherits="UNI.HRHome" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HR Dashboard</title>
    <!-- Main shared style -->
    <link href="Styles/site.css" rel="stylesheet" />
</head>
<body>
    <!-- TOP NAVBAR -->
    <div class="top-navbar">
        <div class="container">
            <!-- Brand -->
            <div class="brand">
                <span class="logo-dot"></span>
                UniBlossom HR
            </div>

            <!-- Main navigation -->
            <ul class="nav">
                <li><a href="HRHome.aspx">Dashboard</a></li>

                <li>
                    <a href="#">Attendance ▾</a>
                    <div class="dropdown-panel">
                        <a href="HRDeductions.aspx">Deductions</a>
                    </div>
                </li>

                <li>
                    <a href="HRPayroll.aspx">Payroll</a>
                </li>

                <li>
                    <a href="#">Leaves ▾</a>
                    <div class="dropdown-panel">
                        <a href="HRApproval.aspx">Approve / Reject</a>
                    </div>
                </li>
            </ul>

            <!-- Right side: Logout -->
            <div class="nav-end">
                <a href="LogIn.aspx">Logout</a>
            </div>
        </div>
    </div>

    <!-- MAIN PAGE CONTENT -->
    <form id="form1" runat="server">
        <div class="container-page">
            <h2 class="page-title">HR Dashboard</h2>

            <!-- Welcome card -->
            <div class="card">
                <asp:Label ID="lblWelcome" runat="server"></asp:Label>
            </div>

            <!-- Quick actions card -->
            <div class="card">
                <h3>Quick HR Actions</h3>
                <p>Select an option below:</p>
                <br />

                <asp:Button ID="btnLeaves" runat="server"
                    Text="Approve / Reject Leaves"
                    CssClass="btn"
                    OnClick="btnLeaves_Click" />

                <asp:Button ID="btnDeductions" runat="server"
                    Text="Manage Deductions"
                    CssClass="btn"
                    OnClick="btnDeductions_Click" />

                <asp:Button ID="btnPayroll" runat="server"
                    Text="Generate Payroll"
                    CssClass="btn"
                    OnClick="btnPayroll_Click" />
            </div>

            <!-- Extra logout button (optional) -->
            <div class="card">
                <asp:Button ID="btnLogout" runat="server"
                    Text="Logout"
                    CssClass="btn"
                    OnClick="btnLogout_Click" />
            </div>
        </div>
    </form>
</body>
</html>
