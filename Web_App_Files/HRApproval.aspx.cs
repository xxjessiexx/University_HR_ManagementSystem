using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace UNI
{
    public partial class HRApproval : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["HRID"] == null)
                {
                    Response.Redirect("LogIn.aspx");
                    return;
                }
            }
        }

        protected void btnBackHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("HRHome.aspx");
        }

        protected void btnProcess_Click(object sender, EventArgs e)
        {
            int hrId = (int)Session["HRID"];
            int requestId;

            if (!int.TryParse(txtRequestID.Text, out requestId))
            {
                lblMessage.CssClass = "error";
                lblMessage.Text = "❌ Request ID must be a number.";
                return;
            }

            string leaveType = ddlLeaveType.SelectedValue;
            string procName = leaveType == "an_acc"
                ? "HR_approval_an_acc"
                : leaveType == "unpaid"
                    ? "HR_approval_Unpaid"
                    : "HR_approval_comp";

            string connStr = ConfigurationManager.ConnectionStrings["GUCera"].ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(procName, conn);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@request_ID", requestId);
                    cmd.Parameters.AddWithValue("@HR_ID", hrId);
                    cmd.ExecuteNonQuery();

                    SqlCommand getStatus = new SqlCommand(
                        "SELECT final_approval_status FROM [Leave] WHERE request_ID = @rId", conn);
                    getStatus.Parameters.AddWithValue("@rId", requestId);

                    object statusObj = getStatus.ExecuteScalar();

                    if (statusObj == null)
                    {
                        lblMessage.CssClass = "error";
                        lblMessage.Text = "❌ No such request ID.";
                        return;
                    }

                    string status = statusObj.ToString().ToLower();

                    if (status == "approved")
                    {
                        lblMessage.CssClass = "success";
                        lblMessage.Text = $"✔ Leave request {requestId} approved successfully.";
                    }
                    else if (status == "rejected")
                    {
                        lblMessage.CssClass = "error";
                        lblMessage.Text = $"❌ Leave request {requestId} was rejected.";
                    }
                    else
                    {
                        lblMessage.CssClass = "pending";
                        lblMessage.Text = $"ℹ Leave request {requestId} is still pending.";
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.CssClass = "error";
                lblMessage.Text = "❌ Error: " + ex.Message;
            }
        }
    }
}
