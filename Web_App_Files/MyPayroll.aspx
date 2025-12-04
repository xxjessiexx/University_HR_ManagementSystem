<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyPayroll.aspx.cs" Inherits="HR.MyPayroll" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Payroll</title>
    <link rel="stylesheet" href="Styles/site.css" />
</head>

<body>
<form id="form1" runat="server">

    <!-- 🌸 SAKURA NAVBAR -->
    <header class="top-navbar">
        <div class="container">
            <div class="brand"><span class="logo-dot"></span>UniBlossom HR</div>

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

    <li>
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

    <!-- 🌸 PAGE WRAPPER -->
    <div class="container-page">

        <div class="page-title">My Payroll</div>

        <!-- Load Button -->
        <div class="card">
            <asp:Button 
                ID="btnGetPayroll" 
                runat="server" 
                Text="Load Payroll" 
                CssClass="btn"
                OnClick="GetPayroll_Click" />
            <asp:Label ID="errorLabel" runat="server" Visible="false" CssClass="error"></asp:Label>
        </div>

        <!-- Payroll Table -->
        <div class="card">
            <h3>Salary Details</h3>
            <asp:GridView 
                ID="gvPayroll" 
                runat="server" 
                AutoGenerateColumns="true"
                CssClass="table">
            </asp:GridView>
        </div>

    </div>

</form>
</body>
</html>
