<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HRPayroll.aspx.cs" Inherits="UNI.HRPayroll" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HR – Generate Payroll</title>
    <link href="Styles/site.css" rel="stylesheet" />
</head>
<body>
    <!-- TOP NAVBAR (same as HRHome / HRApproval / HRDeductions) -->
    <div class="top-navbar">
        <div class="container">
            <div class="brand">
                <span class="logo-dot"></span>
                UniBlossom HR
            </div>

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

            <div class="nav-end">
                <a href="LogIn.aspx">Logout</a>
            </div>
        </div>
    </div>

    <form id="form1" runat="server">
        <div class="container-page">
            <h2 class="page-title">Generate Monthly Payroll</h2>

            <!-- Input card -->
            <div class="card">
                <h3>Payroll Parameters</h3>
                <p>Enter the employee ID and the period you want to generate payroll for.</p>
                <br />

                <label for="txtEmpID">Employee ID</label>
                <asp:TextBox ID="txtEmpID" runat="server" TextMode="Number"></asp:TextBox>
                <br /><br />

                <label for="txtFromDate">From Date</label>
                <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date"></asp:TextBox>
                <br /><br />

                <label for="txtToDate">To Date</label>
                <asp:TextBox ID="txtToDate" runat="server" TextMode="Date"></asp:TextBox>
                <br /><br />

                <asp:Button ID="btnGenerate" runat="server"
                    Text="Generate Payroll"
                    CssClass="btn"
                    OnClick="btnGenerate_Click" />

                <br /><br />
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </div>
        </div>
    </form>
</body>
</html>
