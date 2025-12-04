<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyPerformance.aspx.cs" Inherits="HR.MyPerformance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Performance</title>
    <link rel="stylesheet" href="Styles/site.css" />
</head>
<body>

<form id="form1" runat="server">

    <!-- 🌸 SAKURA NAVBAR -->
    <header class="top-navbar">
        <div class="container">

            <div class="brand">
                <span class="logo-dot"></span>
              UniBlossom HR
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

                <li>
                    <a href="#" class="nav-btn">Performance ▾</a>
                    <div class="dropdown-panel">
                        <a href="MyPerformance.aspx">My Performance</a>
                    </div>
                </li>

                <li>
                    <a href="#" class="nav-btn">Leaves ▾</a>
                    <div class="dropdown-panel">
                        <a href="SubmitAnnualLeave.aspx">Submit Annual Leave</a>
                        <a href="LeaveStatus.aspx">Leave Status</a>
                    </div>
                </li>

                <li><a class="deductions" href="MyDeductions.aspx">Deductions</a></li>

            </ul>

            <div class="nav-end">
                <a href="LogIn.aspx">Logout</a>
            </div>

        </div>
    </header>

    <!-- 🌸 PAGE BODY -->
    <div class="container-page">

        <div class="page-title">My Performance</div>

        <div class="card">
            <label>Semester (e.g. S25, W24):</label>
            <asp:TextBox ID="semesterTextBox" runat="server"></asp:TextBox>

            <asp:Button 
                ID="btnGetPerformance" 
                runat="server" 
                Text="Get Performance" 
                CssClass="btn"
                OnClick="GetPerformance_Click" />
            
            <asp:Label 
                ID="errorLabel" 
                runat="server" 
                Visible="false" 
                CssClass="error">
            </asp:Label>
        </div>

        <div class="card">
            <h3>Performance Results</h3>
            <asp:GridView 
                ID="gvPerformance" 
                runat="server" 
                AutoGenerateColumns="true"
                CssClass="table">
            </asp:GridView>
        </div>

    </div>

</form>
</body>
</html>
