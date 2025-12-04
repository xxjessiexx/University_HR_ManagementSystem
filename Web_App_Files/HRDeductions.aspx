<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="HRDeductions.aspx.cs"
    Inherits="UNI.HRDeductions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Deductions Management</title>
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

            <!-- Logout -->
            <div class="nav-end">
                <a href="LogIn.aspx">Logout</a>
            </div>

        </div>
    </div>


    <!-- MAIN CONTENT -->
    <form id="form1" runat="server">
        <div class="container-page">
            <h2 class="page-title">Deductions Management</h2>

            <!-- Main card -->
            <div class="card">
                <h3>Calculate Deductions for an Employee</h3>
                <p>Enter an Employee ID and choose the deduction type.</p>
                <br />

                <label>Employee ID</label>
                <asp:TextBox ID="txtEmpID" runat="server"></asp:TextBox>

                <br /><br />

                <asp:Button ID="btnMissingHours" runat="server"
                    Text="Add Missing Hours Deduction"
                    CssClass="btn"
                    OnClick="btnMissingHours_Click" />
                
                <asp:Button ID="btnMissingDays" runat="server"
                    Text="Add Missing Days Deduction"
                    CssClass="btn"
                    OnClick="btnMissingDays_Click" />
                
                <asp:Button ID="btnUnpaidDeduction" runat="server"
                    Text="Add Unpaid Leave Deduction"
                    CssClass="btn"
                    OnClick="btnUnpaidDeduction_Click" />

                <br /><br />

                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </div>

            <!-- Back -->
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
