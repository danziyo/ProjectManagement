Create PROCEDURE [dbo].[ZhengJianTiXingChaXun] 
@CurUser varchar(20)    
AS 
    IF OBJECT_ID('#֤�����ѱ�') is not null  
       drop table #֤�����ѱ�
 
    Create Table #֤�����ѱ� (ZJAutoID Int ,֤��״̬ [nvarchar] (50),���ѱ�ע [nvarchar] (255),֤������ [nvarchar] (50),
    ��֤������ [nvarchar] (30),��Чʱ�� SmallDateTime,������ [nvarchar] (100),��Ӧ���� [nvarchar] (20),�������� [nvarchar] (20),DJAutoID Int)
     
   Declare @ZJMC varchar(100)
   Declare @CZRXM varchar(50)
   Declare @TXBZ varchar(1000)
   Declare @TQTXTS Int
   Declare @YXSJ SmallDateTime
   Declare @ZJAutoID Int
   Declare @Sql varchar(1000)
   Declare @Sql2 varchar(1000)
   
   Declare @DYDJ varchar(20)
   Declare @DJLX varchar(20)
   Declare @DJAutoID Int
   Declare @TXR varchar(100)
   
   Declare @ADYDJ varchar(20)
   Declare @ADJLX varchar(20)
   Declare @ADJAutoID Int
   
   Declare @YJGHRQ SmallDateTime
   Declare @JHR varchar(20)
   
   Declare @TXZT varchar(100)
   Declare @TXXX varchar(100)
   
  --  AutoID,��Ŀ����,����,���,��ͬ���,��ͬ����,�����ܶ����,�׷�,�ҷ�,ʩ����ʼʱ��,ʩ������ʱ��,��ͬǩ������'
  --  ���ͽ��,��ͬ���,���ݸ������,�����޶�,���̸ſ�,����Լ������,Ӧ����Լ��֤��,�۹���ѷ���,���������,�������ѷ���'
 
    Set @sql='Declare cur_ZhengJian Cursor Global For Select ֤������,��֤������,������,���ѱ�ע,��ǰ��������,��Чʱ��,AutoID From ֤���� where 1=1'
    IF @CurUser<>'' 
    Begin
      Set @sql=@sql+' And CharIndex('''+@CurUser+''',������)>0 '
    End
    
    Exec(@Sql)
    Open cur_ZhengJian
    Fetch Next From cur_ZhengJian into @ZJMC,@CZRXM,@TXR,@TXBZ,@TQTXTS,@YXSJ,@ZJAutoID
    
    While (@@Fetch_Status=0)
    Begin  
      Set @TXZT=''
      Set @TXXX=''
      Set @TXBZ=IsNULL(@TXBZ,'')
      IF (@TQTXTS>0) And ( DATEDIFF(day,  getdate(),@YXSJ-@TQTXTS)<1 )
      Begin
        Set @TXZT='֤������'
        IF @TXBZ=''
        Begin
          Set @TXBZ='1��֤�����ڣ������Ƿ���Ҫ���'
        End
        Set @TXXX=@TXBZ
      End
        
      Set @DYDJ=''
      Set @DJLX=''
      Set @DJAutoID=-1
        
      Set @sql2='Declare cur_YeWu Cursor Global For Select Top 1 ��Ӧ����,��������,AutoID,Ԥ�ƹ黹����,�軹�� From ֤����ϸ�� where ����=0 And ֤������='''+@ZJMC+''' And ��֤������='''+@CZRXM+''' order by �������� DESC'
      Exec(@Sql2)
      Open cur_YeWu
      Fetch Next From cur_YeWu into @ADYDJ,@ADJLX,@ADJAutoID,@YJGHRQ,@JHR
      IF (@@Fetch_Status=0)
      Begin
        IF (@ADJLX='֤�������') And ( DATEDIFF(day,  getdate(),@YJGHRQ)<1 )
        Begin
          IF @TXZT<>''
          Begin
            Set @TXZT=@TXZT+'��'
          End
          IF @TXXX<>''
          Begin
            Set @TXXX=@TXXX+'��'
          End
          
          Set @TXZT=@TXZT+'δ������'
          Set @TXXX=@TXXX+'2������ˣ�'+@JHR+'��Լ���黹���ڣ�'+  CONVERT(varchar(100), @YJGHRQ, 23) 
          IF  DATEDIFF(day,  getdate(),@YJGHRQ)=0 
          Begin
            Set @TXXX=@TXXX+'�����죩'
          End
          IF  DATEDIFF(day,  getdate(),@YJGHRQ)<0
          Begin
              Set @TXXX=@TXXX+'���ѳ���'+ LTrim(Str(DATEDIFF(day, @YJGHRQ, getdate())))+'��'
          End
       
          Set @DYDJ=@ADYDJ
          Set @DJLX=@ADJLX
          Set @DJAutoID=@ADJAutoID
        End
           
      End
 

      Close cur_YeWu
      Deallocate cur_YeWu

      -- Create Table  (AutoID Int ,֤��״̬ [nvarchar] (50),���ѱ�ע [nvarchar] (255),֤������ [nvarchar] (50),
      -- ��֤������ [nvarchar] (30),ԭʼ���� [nvarchar] (20),�������� [nvarchar] (20),ZJAutoID Int)
      IF (@TXZT<>'')
      Begin
        Insert into #֤�����ѱ� values(@ZJAutoID,@TXZT,@TXXX,@ZJMC,@CZRXM,@YXSJ,@TXR,@DYDJ,@DJLX,@DJAutoID)
      End
  
      Fetch Next From cur_ZhengJian into @ZJMC,@CZRXM,@TXR,@TXBZ,@TQTXTS,@YXSJ,@ZJAutoID

    End
    
    Close cur_ZhengJian
    deallocate cur_ZhengJian
      
    Select * from #֤�����ѱ�