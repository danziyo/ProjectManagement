Create PROCEDURE  [dbo].[GetYSLInfo3]
@GZ varchar(50) ,
@CLMC varchar(200) ,
@GG varchar(150) ,
@DW varchar(50) ,
@XMMC varchar(200) ,
@BWMC varchar(100) ,
@JHDAutoID Int ,
@CGKZJ Float output,
@XMYSSL Float output,
@XMYSDJ Float output, 
@BWYSSL Float output,
@BWYSDJ Float output,
@BWXHL Float output,
@XMDHL Float output,
@XMKCL Float output,
@XMYSBL Float output,
@FoundXMCL Bit output,
@FoundBWCL Bit output,
@CanNotSaveByNoYs Bit output,
@CanNotSaveByChaoYs Bit output 
AS
BEGIN  

  declare @Sql_Str Varchar(1000)
  declare @ThisYSDID Int
  declare @ThisXMAutoID Int
  declare @ThisXMPathKey Varchar(255)

  declare @XMYSBL2 Float
  declare @JSFS Varchar(255)
  declare @HZDJID Varchar(255)
  declare @XMYSJE Float
  declare @BWYSJE Float  
  declare @LjCount Int
  
  Set @ThisYSDID=-1
  Set @ThisXMAutoID=''
  Set @ThisXMPathKey='' 
  Set @CanNotSaveByNoYs=0 
  Set @CanNotSaveByChaoYs=0 

  Set @Sql_Str='Declare cur1 Cursor Global For Select AutoID,Ԥ�㵥ID,�ƻ�����Ԥ��,�ƻ�����Ԥ��,PathKey From ��Ŀ�� where ��Ŀ���� ='''+@XMMC+''''
  Exec(@Sql_Str)
  Open cur1 
  Fetch Next From cur1 into @ThisXMAutoID,@ThisYSDID,@CanNotSaveByNoYs,@CanNotSaveByChaoYs,@ThisXMPathKey
  Close cur1
  deallocate cur1

 

  IF @@Fetch_Status<>0 
  Begin
     Return
  End 
  --MainF.OpenCaiLiaoYuSuanContQuy(ThisYSDID,ThisADOQuery);

  Set @CGKZJ=0
  Set @XMYSSL=0
  Set @XMYSDJ=0
  Set @BWYSSL=0
  Set @BWYSDJ=0
  Set @BWXHL=0
  Set @XMDHL=0
  Set @XMKCL=0
  Set @XMYSBL=0
  Set @XMYSBL2=0
 
  IF @ThisYSDID <>-1 
  Begin

    Set @Sql_Str='Declare cur2 Cursor Global For Select ���㷽ʽ,���ܵ����б� From ����Ԥ���ܱ� where AutoID='+LTrim(Str(@ThisYSDID))
    Exec(@Sql_Str)
    Open cur2 
    Fetch Next From cur2 into @JSFS,@HZDJID
    Close cur2
    deallocate cur2 

    Set @HZDJID=';'+Replace(@HZDJID,CHAR(13)+CHAR(10),';')

    IF @@Fetch_Status<>0 
    Begin
       Return
    End 

    IF @JSFS='�Զ���' or @JSFS='�Զ���+����' 
    Begin
      print @JSFS

      IF @JSFS='�Զ���' 
      Begin
        Set @Sql_Str='Declare cur3 Cursor Global For Select Count(*) As LjCount, Min(�ɹ����Ƽ�) As CGKZJ,Sum(�ƻ�����) As SL,Sum(�ƻ����) As JE  From ����Ԥ����ϸ�� where MainID='+LTrim(Str(@ThisYSDID))+' And ����='''+@GZ+''' And ��������='''+@CLMC+''' And ���='''+@GG+''' And ��λ='''+@DW+''''
      End
      
      IF @JSFS<>'�Զ���'    --'�Զ���+����' 
      Begin
        Set @HZDJID=';'+Replace(@HZDJID,CHAR(13)+CHAR(10),';')
        Set @Sql_Str='Declare cur3 Cursor Global For Select Count(*) As LjCount, Min(�ɹ����Ƽ�) As CGKZJ,Sum(�ƻ�����) As SL,Sum(�ƻ����) As JE  From ����Ԥ����ϸ�� where ����='''+@GZ+''' And ��������='''+@CLMC+''' And ���='''+@GG+''' And ��λ='''+@DW+''''
        Set @Sql_Str=@Sql_Str+' And ( MainID='+LTrim(Str(@ThisYSDID))+' or CharIndex('';''+LTrim(Str(MainID))+'';'','''+@HZDJID+''')>0 )' 
      End
 
      Exec(@Sql_Str)
      Open cur3 

      Fetch Next From cur3 into @LjCount,@CGKZJ,@XMYSSL,@XMYSJE
    
 
      IF @LjCount>0 
      Begin
        Set @FoundXMCL=1
      End
    
      Close cur3
      deallocate cur3

    End



    IF @CGKZJ Is NULL
    Begin
        Set @CGKZJ=0
    End

    IF @XMYSSL Is NULL
    Begin
      Set @XMYSSL=0
    End

    IF @XMYSJE Is NULL
    Begin
      Set @XMYSJE=0
    End

    IF @XMYSSL<>0
    Begin 
      Set @XMYSDJ=@XMYSJE/@XMYSSL
    End
  End 

  IF (@BWMC<>'') And (@XMMC<>'')    --������ò�λ
  Begin
    Set @Sql_Str='Declare cur5 Cursor Global For Select YSDID From ��Ŀ��λ�ֽ� where MainID='+LTrim(Str(@ThisXMAutoID)) +' And ��λ����='''+@BWMC+'''' 
    Exec(@Sql_Str)
    Open cur5
    Fetch Next From cur5 into @ThisYSDID  
 
    IF @@Fetch_Status=0 
    Begin 
      Set @Sql_Str='Declare cur6 Cursor Global For Select ���㷽ʽ,���ܵ����б� From ����Ԥ���ܱ� where AutoID='+LTrim(Str(@ThisYSDID))
      Exec(@Sql_Str)
      Open cur6
      Fetch Next From cur6 into @JSFS,@HZDJID

      Set @HZDJID=';'+Replace(@HZDJID,CHAR(13)+CHAR(10),';')

      IF @JSFS='�Զ���' or @JSFS='�Զ���+����' 
      Begin 
        IF @JSFS='�Զ���' 
        Begin
          Set @Sql_Str='Declare cur7 Cursor Global For Select Sum(�ƻ�����) As SL,Sum(�ƻ����) As JE  From ����Ԥ����ϸ�� where MainID='+LTrim(Str(@ThisYSDID))+' And ����='''+@GZ+''' And ��������='''+@CLMC+''' And ���='''+@GG+''' And ��λ='''+@DW+''''
        End
        IF @JSFS='�Զ���+����'
        Begin
          Set @HZDJID=';'+Replace(@HZDJID,CHAR(13)+CHAR(10),';')
          Set @Sql_Str='Declare cur7 Cursor Global For Select Sum(�ƻ�����) As SL,Sum(�ƻ����) As JE  From ����Ԥ����ϸ�� where ����='''+@GZ+''' And ��������='''+@CLMC+''' And ���='''+@GG+''' And ��λ='''+@DW+''''
          Set @Sql_Str=@Sql_Str+' And ( MainID='+LTrim(Str(@ThisYSDID))+' or CharIndex('';''+LTrim(Str(MainID))+'';'','''+@HZDJID+''')>0 )' 
        End

 
        Exec(@Sql_Str)
        Open cur7
   
        Fetch Next From cur7 into @BWYSSL,@BWYSJE


        IF @BWYSSL IS NULL
        Begin
          Set @BWYSSL=0 
        End
        IF @BWYSSL<>0
        Begin 
          Set @FoundBWCL=1
          Set @BWYSDJ=@BWYSJE/@BWYSSL
        End 
      
        Close cur7
        deallocate cur7 
 
      End

      Close cur6
      deallocate cur6
 
    End 

    Close cur5
    Deallocate cur5   
  
  End 

  Set @Sql_Str='Declare cur4 Cursor Global For Select Sum(����*�ⷿ����) As KCL, Sum(����*(��Ŀ����+�ⷿ����)) As SL From ������ϸ�� where CharIndex('''+@ThisXMPathKey+''',XMPathKey)=1 And ����=0 And ����='''+@GZ+''' And ����='''+@CLMC+''' And ��λ='''+@DW+''''

  IF @GG<>''
  Begin
    Set @Sql_Str=@Sql_Str+' And ���='''+@GG+'''' 
  End

  Exec(@Sql_Str)
  Open cur4 
  Fetch Next From cur4 into @XMKCL,@XMDHL
  Close cur4
  deallocate cur4
  
  IF @XMKCL Is NULL 
  Begin  
    Set @XMKCL=0
  End

  IF @XMDHL Is NULL 
  Begin  
    Set @XMDHL=0
  End

 
  IF @BWMC<>'' 
  Begin

    Set @Sql_Str='Declare cur8 Cursor Global For Select Count(*) As LjCount, Sum(����*��Ŀ����) As SL from ������ϸ�� where CharIndex('''+@ThisXMPathKey+''',XMPathKey)=1 And ���ò�λ='''+@BWMC+''' And ����=0 And ����='''+@GZ+''' And ����='''+@CLMC+''' And ��λ='''+@DW+''''
    IF @GG<>'' 
    Begin
       Set @Sql_Str=@Sql_Str+' And ���='''+@GG+'''' 
    End
 
    Exec(@Sql_Str)
    Open cur8
    Fetch Next From cur8 into @LjCount,@BWXHL
   
    Close cur8
    deallocate cur8

    IF @BWXHL Is NULL 
    Begin  
      Set @BWXHL=0
    End

  End
 

  Set @Sql_Str='Declare cur9 Cursor Global For Select Sum(�ϱ��ƻ���) As SBL From ���ϼƻ���ϸ�� where  CharIndex('''+@ThisXMPathKey+''',JHXMPathKey)=1 '
  Set @Sql_Str=@Sql_Str+' And MainID In (Select AutoID From ���ϼƻ����˱� where ����=0   )'
  Set @Sql_Str=@Sql_Str+' And ����='''+@GZ+''' And ��������='''+@CLMC+''' And ��λ='''+@DW+''''

  IF @GG<>''
  Begin
    Set @Sql_Str=@Sql_Str+' And ���='''+@GG+'''' 
  End

  IF @BWMC<>''
  Begin
    Set @Sql_Str=@Sql_Str+' And ���ò�λ='''+@BWMC+''''
  End

  IF @JHDAutoID<>-1 
  Begin
    Set @Sql_Str=@Sql_Str+' And MainID<>'+LTrim(Str(@JHDAutoID))  
  End

  Exec(@Sql_Str)
  Open cur9
  Fetch Next From cur9 into @XMYSBL
  Close cur9
  deallocate cur9

  IF @XMYSBL Is NULL 
  Begin
    Set @XMYSBL=0
  End


  Set @Sql_Str='Declare cur10 Cursor Global For Select Sum(�ϱ��ƻ���) As SBL From ���ϼƻ���ϸ�� where ( (JHXMPathKey Is NULL) or (JHXMPathKey='''') ) And MainID In (Select AutoID From ���ϼƻ����˱� where CharIndex('''+@ThisXMPathKey+''',XMPathKey)=1 And ����=0) '
  Set @Sql_Str=@Sql_Str+' And ����='''+@GZ+''' And ��������='''+@CLMC+''' And ��λ='''+@DW+''''
  IF @GG<>'' 
     Set @Sql_Str=@Sql_Str+' And ���='''+@GG+'''' 
 
  IF @BWMC<>'' 
     Set @Sql_Str=@Sql_Str+' And ���ò�λ='''+@BWMC+''''
    
  IF @JHDAutoID<>-1 
  Begin
    Set @Sql_Str=@Sql_Str+' And MainID<>'+LTrim(Str(@JHDAutoID))  
  End


  Exec(@Sql_Str)
  Open cur10
  Fetch Next From cur10 into @XMYSBL2
  Close cur10
  deallocate cur10

  IF @XMYSBL2 Is NULL 
  Begin
    Set @XMYSBL2=0
  End

  Set @XMYSBL=@XMYSBL+@XMYSBL2 

EnD
