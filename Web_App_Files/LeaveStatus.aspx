<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LeaveStatus.aspx.cs" Inherits="HR.LeaveStatus" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Leave Status</title>
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

                <li>
                    <a href="#" class="nav-btn">Payroll ▾</a>
                    <div class="dropdown-panel">
                        <a href="MyPayroll.aspx">My Payroll</a>
                    </div>
                </li>

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


    <!-- 🌸 PAGE CONTENT -->
    <div class="container-page">

        <div class="page-title">My Leave Status</div>

        <!-- Button Card -->
        <div class="card">
            <asp:Button ID="btnViewLeaveStatus" runat="server" CssClass="btn"
                Text="View My Leave Status" OnClick="ViewLeaveStatus_Click" />
        </div>

        <!-- Leave Status Table -->
        <div class="card">

            <asp:GridView ID="gvLeaveStatus" runat="server" CssClass="table"
                AutoGenerateColumns="False"
                EmptyDataText="No leave records found for the current month."
                GridLines="None">

                <Columns>
                    <asp:BoundField DataField="request_ID" HeaderText="Request ID" />
                    <asp:BoundField DataField="date_of_request" HeaderText="Request Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="final_approval_status" HeaderText="Status" />
                </Columns>

            </asp:GridView>

            <asp:Label ID="lblLeaveStatusError" runat="server" CssClass="error" Visible="false"></asp:Label>

        </div>
    </div>

</form>
</body>

</html>
