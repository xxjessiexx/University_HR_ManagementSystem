<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="HRApproval.aspx.cs"
    Inherits="UNI.HRApproval" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Approve / Reject Leaves</title>
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

            <!-- Main Navigation -->
            <ul class="nav">
                <li><a href="HRHome.aspx">Dashboard</a></li>

                <li>
                    <a href="#">Attendance ▾</a>
                    <div class="dropdown-panel">
                        <a href="HRDeductions.aspx">Deductions</a>
                    </div>
                </li>

                <li><a href="HRPayroll.aspx">Payroll</a></li>

                <li>
                    <a href="#">Leaves ▾</a>
                    <div class="dropdown-panel">
                        <a href="HRApproval.aspx">Approve / Reject</a>
                    </div>
                </li>
            </ul>

            <!-- Logout Button -->
            <div class="nav-end">
                <a href="LogIn.aspx">Logout</a>
            </div>

        </div>
    </div>


    <!-- MAIN PAGE CONTENT -->
    <form id="form1" runat="server">
        <div class="container-page">

            <h2 class="page-title">Approve / Reject Leaves</h2>

            <!-- Input Card -->
            <div class="card">

                <h3>Process a Leave Request</h3>

                <label>Request ID</label>
                <asp:TextBox ID="txtRequestID" runat="server"
                    CssClass="input"></asp:TextBox>

                <br /><br />

                <label>Leave Type</label>
                <asp:DropDownList ID="ddlLeaveType" runat="server"
                    CssClass="input">
                    <asp:ListItem Text="Annual / Accidental" Value="an_acc"></asp:ListItem>
                    <asp:ListItem Text="Unpaid" Value="unpaid"></asp:ListItem>
                    <asp:ListItem Text="Compensation" Value="comp"></asp:ListItem>
                </asp:DropDownList>

                <br /><br />

                <asp:Button ID="btnProcess" runat="server"
                    CssClass="btn"
                    Text="Process Leave"
                    OnClick="btnProcess_Click" />

                <br /><br />

                <!-- Output message -->
                <asp:Label ID="lblMessage" runat="server"
                    CssClass="success"></asp:Label>

            </div>

            <!-- Back Button -->
            <div class="card">
                <asp:Button ID="btnBackHome" runat="server"
                    Text="← Back to HR Home"
                    CssClass="btn"
                    OnClick="btnBackHome_Click" />
            </div>

        </div>
    </form>

</body>
</html>

