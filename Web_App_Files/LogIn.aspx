<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogIn.aspx.cs" Inherits="HR.LogIn" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Login</title>
    <link rel="stylesheet" href="Styles/site.css" />
</head>

<body>
    <header class="top-navbar">
    <div class="container">
        <div class="brand">
            <span class="logo-dot"></span>UniBlossom HR
        </div>

                   <ul class="nav">
    <li><a href="EmployeeHome.aspx">Dashboard</a></li>

    <li>
        <a href="#" class="nav-btn">Attendance ▾</a>
        <div class="dropdown-panel">
            <a href="MyAttendance.aspx">My Attendance</a>
            <a href="MyDeductions.aspx">My Deductions</a>
        </div>
    </li>

    <li><a href="MyPayroll.aspx">Payroll</a></li>
    <li><a href="MyPerformance.aspx">Performance</a></li>

    <li >
        <a href="#" class="nav-btn">Leaves ▾</a>
        <div class="dropdown-panel">
            <a href="SubmitAnnualLeave.aspx">Submit Annual Leave</a>
            <a href="SubmitAccidentalLeave.aspx">Submit Accidental Leave</a>
            <a href="SubmitCompensationLeave.aspx">Submit Compensation Leave</a>
            <a href="SubmitMedicalLeave.aspx">Submit Medical Leave</a>
            <a href="SubmitUnpaidLeave.aspx">Submit Unpaid Leave</a>
            <a href="LeaveStatus.aspx">Leave Status</a>
        </div>
    </li>

    <li><a href="MyDeductions.aspx">Deductions</a></li>
</ul>

        <div class="nav-end">
            <a href="LogIn.aspx">Logout</a>
        </div>
    </div>
</header>

    <form id="form1" runat="server">

        <div class="container-page" style="max-width:430px; margin-top:80px;">
            
            <div class="page-title" style="text-align:center;">
                Employee Login
            </div>

            <div class="card">

                <label>User Name</label>
                <asp:TextBox ID="UserName" runat="server"></asp:TextBox>

                <label>Password</label>
                <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>

                <asp:Button 
                    ID="Button1" 
                    runat="server" 
                    Text="Log In" 
                    CssClass="btn"
                    OnClick="Login" />

                <asp:Label 
                    ID="errorLabel" 
                    runat="server" 
                    CssClass="error" 
                    Visible="false">
                </asp:Label>

            </div>

        </div>

    </form>

</body>
</html>
